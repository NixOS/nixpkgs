{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.taler;
  settingsFormat = pkgs.formats.ini { };
in

{
  # TODO turn this into a generic taler-like service thingy?
  options.services.taler = {
    enable = lib.mkEnableOption "the GNU Taler system" // lib.mkOption { internal = true; };
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files to include into the config file using Taler's `@inline@` directive.

        This allows including arbitrary INI files, including imperatively managed ones.
      '';
    };
    settings = lib.mkOption {
      description = ''
        Global configuration options for the taler config file.

        For a list of all possible options, please see the man page [`taler.conf(5)`](https://docs.taler.net/manpages/taler.conf.5.html)
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          taler = {
            CURRENCY = lib.mkOption {
              type = lib.types.nonEmptyStr;
              description = ''
                The currency which taler services will operate with. This cannot be changed later.
              '';
            };
            CURRENCY_ROUND_UNIT = lib.mkOption {
              type = lib.types.str;
              default = "${cfg.settings.taler.CURRENCY}:0.01";
              defaultText = lib.literalExpression ''
                "''${config.services.taler.settings.taler.CURRENCY}:0.01"
              '';
              description = ''
                Smallest amount in this currency that can be transferred using the underlying RTGS.

                You should probably not touch this.
              '';
            };
          };
        };
      };
      default = { };
    };
    runtimeDir = lib.mkOption {
      type = lib.types.str;
      default = "/run/taler-system-runtime/";
      description = ''
        Runtime directory shared between the taler services.

        Crypto helpers put their sockets here for instance and the httpd
        connects to them.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.taler.settings.PATHS = {
      TALER_DATA_HOME = "\${STATE_DIRECTORY}/";
      TALER_CACHE_HOME = "\${CACHE_DIRECTORY}/";
      TALER_RUNTIME_DIR = cfg.runtimeDir;
    };

    environment.etc."taler/taler.conf".source =
      let
        includes = pkgs.writers.writeText "includes.conf" (
          lib.concatStringsSep "\n" (map (include: "@inline@ ${include}") cfg.includes)
        );
        generatedConfig = settingsFormat.generate "generated-taler.conf" cfg.settings;
      in
      pkgs.runCommand "taler.conf" { } ''
        cat ${includes} > $out
        echo >> $out
        echo >> $out
        cat ${generatedConfig} >> $out
      '';

  };
}
