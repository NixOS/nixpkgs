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

        manualCache =
          pkgs.runCommand "man-cache"
            {
              nativeBuildInputs = [ buildPackage ];
            }
            ''
              echo "MANDB_MAP ${cfg.manualPages}/share/man $out" > man.conf
              mandb -C man.conf -psc >/dev/null 2>&1
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
