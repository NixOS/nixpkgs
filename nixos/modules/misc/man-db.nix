{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.documentation.man.man-db;
in

{
  options = {
    documentation.man.man-db = {
      enable = lib.mkEnableOption "man-db as the default man page viewer" // {
        default = config.documentation.man.enable;
        defaultText = lib.literalExpression "config.documentation.man.enable";
        example = false;
      };

      skipPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        internal = true;
        description = ''
          Packages to *not* include in the man-db.
          This can be useful to avoid unnecessary rebuilds due to packages that change frequently, like nixos-version.
        '';
      };

      manualPages = lib.mkOption {
        type = lib.types.path;
        default = pkgs.buildEnv {
          name = "man-paths";
          paths = lib.subtractLists cfg.skipPackages config.environment.systemPackages;
          pathsToLink = [ "/share/man" ];
          extraOutputsToInstall = [ "man" ] ++ lib.optionals config.documentation.dev.enable [ "devman" ];
          ignoreCollisions = true;
        };
        defaultText = lib.literalMD "all man pages in {option}`config.environment.systemPackages`";
        description = ''
          The manual pages to generate caches for if {option}`documentation.man.generateCaches`
          is enabled. Must be a path to a directory with man pages under
          `/share/man`; see the source for an example.
          Advanced users can make this a content-addressed derivation to save a few rebuilds.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.man-db;
        defaultText = lib.literalExpression "pkgs.man-db";
        description = ''
          The `man-db` derivation to use. Useful to override
          configuration options used for the package.
        '';
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "documentation" "man" "manualPages" ]
      [ "documentation" "man" "man-db" "manualPages" ]
    )
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."man_db.conf".text =
      let
        # We unfortunately can’t use the customized `cfg.package` when
        # cross‐compiling. Instead we detect that situation and work
        # around it by using the vanilla one, like the OpenSSH module.
        buildPackage =
          if pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform then
            cfg.package
          else
            pkgs.buildPackages.man-db;

        generateMandb =
          package:
          pkgs.runCommand
            (
              with lib.strings;
              let
                storeLength = stringLength storeDir + 34; # Nix' StorePath::HashLen + 2 for the separating slash and dash
                pathName = substring storeLength (stringLength package - storeLength) package;
              in
              (package.name or pathName) + "_man-db"
            )
            (
              {
                nativeBuildInputs = [ buildPackage ];
                preferLocalBuild = true;
              }
              // lib.optionalAttrs (package ? meta.priority) { meta.priority = package.meta.priority; }
            )
            ''
              mkdir -p $out
              if [ -d ${package}/share/man ]; then
                echo "MANDB_MAP ${package}/share/man $out" > man.conf
                mandb -C man.conf -psc >/dev/null 2>&1
              fi
            '';

        extraOutputsToInstall = [ "man" ] ++ lib.optionals config.documentation.dev.enable [ "devman" ];

        manualCache =
          pkgs.runCommand "merged-system-man-db"
            {
              # TODO: use cfg.manualPages
              packages = lib.pipe config.environment.systemPackages [
                (lib.subtractLists cfg.skipPackages)

                # chosenOutputs from pkgs.buildEnv
                (builtins.map (drv: {
                  paths =
                    # First add the usual output(s): respect if user has chosen explicitly,
                    # and otherwise use `meta.outputsToInstall`. The attribute is guaranteed
                    # to exist in mkDerivation-created cases. The other cases (e.g. runCommand)
                    # aren't expected to have multiple outputs.
                    (
                      if
                        (!drv ? outputSpecified || !drv.outputSpecified) && drv.meta.outputsToInstall or null != null
                      then
                        map (outName: drv.${outName}) drv.meta.outputsToInstall
                      else
                        [ drv ]
                    )
                    # Add any extra outputs specified by the caller of `buildEnv`.
                    ++ lib.filter (p: p != null) (builtins.map (outName: drv.${outName} or null) extraOutputsToInstall);
                  priority = drv.meta.priority or lib.meta.defaultPriority;
                }))

                # reverse sort on priority so that man pages from higher priority packages are processed last
                lib.sortProperties
                lib.reverseList

                (builtins.map (p: p.paths))
                lib.lists.flatten

                lib.unique
                (builtins.map generateMandb)
              ];

              nativeBuildInputs = [
                pkgs.findutils
                pkgs.gdbm
              ];
            }
            ''
              # don't fail if there are no man pages
              mkdir -p $out

              for in in $packages; do
                find "$in" -type f -name index.db -printf '%P\n' | while IFS="" read -r db; do
                  mkdir -p "$out/$(dirname $db)"
                  gdbm_dump "$in/$db" | gdbm_load --update --replace --no-meta - "$out/$db"
                done
              done
            '';
      in
      ''
        # Manual pages paths for NixOS
        MANPATH_MAP /run/current-system/sw/bin /run/current-system/sw/share/man
        MANPATH_MAP /run/wrappers/bin          /run/current-system/sw/share/man

        ${lib.optionalString config.documentation.man.generateCaches ''
          # Generated manual pages cache for NixOS (immutable)
          MANDB_MAP /run/current-system/sw/share/man ${manualCache}
        ''}
        # Manual pages caches for NixOS
        MANDB_MAP /run/current-system/sw/share/man /var/cache/man/nixos
      '';
  };
}
