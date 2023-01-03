{ config, pkgs, lib, ... }:

let
  cfg = config.documentation.man.man-db;
in

{
  options = {
    documentation.man.man-db = {
      enable = lib.mkEnableOption (lib.mdDoc "man-db as the default man page viewer") // {
        default = config.documentation.man.enable;
        defaultText = lib.literalExpression "config.documentation.man.enable";
        example = false;
      };

      manualPages = lib.mkOption {
        type = lib.types.path;
        default = pkgs.buildEnv {
          name = "man-paths";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/share/man" ];
          extraOutputsToInstall = [ "man" ]
            ++ lib.optionals config.documentation.dev.enable [ "devman" ];
          ignoreCollisions = true;
        };
        defaultText = lib.literalMD "all man pages in {option}`config.environment.systemPackages`";
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          The `man-db` derivation to use. Useful to override
          configuration options used for the package.
        '';
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "documentation" "man" "manualPages" ] [ "documentation" "man" "man-db" "manualPages" ])
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."man_db.conf".text =
      let
        manualCache = pkgs.runCommand "man-cache" {
          nativeBuildInputs = [ cfg.package ];
        } ''
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
