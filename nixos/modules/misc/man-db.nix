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
                nativeBuildInputs = [
                  cfg.package
                  pkgs.findutils
                ];
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

        paths = lib.pipe config.environment.systemPackages [
          (lib.subtractLists cfg.skipPackages)

          # reverse sort on priority so that man pages from higher priority packages are processed last
          lib.sortProperties
          lib.reverseList
        ];

        # lib.getOutput is insufficient to replicate the behaviour of pkgs.buildEnv:
        #  - lib.getMan pkgs.libressl.nc => pkgs.libressl.nc
        #  - while pkgs.buildEnv with paths= [ pkgs.libressl.nc ] and extraOutputsToInstall = [ "man" ]
        #    will include the output of pkgs.libressl.nc.man
        pathsMan = builtins.map (p: if p ? man then p.man else p) paths;

        pathsDevman = lib.optionals config.documentation.dev.enable (
          builtins.map (p: if p ? devman then p.devman else p) paths
        );

        manualCache =
          pkgs.runCommand "merged-system-man-db"
            {
              # TODO: use cfg.manualPages
              packages = lib.pipe (paths ++ pathsMan ++ pathsDevman) [
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
