{
  lib,
  pkgs,
  config,
  ...
}:

let
  settingsFormat = pkgs.formats.ini { };
  this = config.services.taler;
in

{
  # TODO turn this into a generic taler-like service thingy?
  options.services.taler = {
    enable = lib.mkEnableOption "the GNU Taler system" // lib.mkOption { internal = true; };
    includes = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      description = ''
        Files to include into the config file using Taler's `@inline@` directive.

        This allows including arbitrary INI files, including imperatively managed ones.
      '';
    };
    configFile = lib.mkOption {
      internal = true;
      default =
        let
          includes = pkgs.writers.writeText "includes.conf" (
            lib.concatStringsSep "\n" (map (include: "@inline@ ${include}") this.includes)
          );
          generatedConfig = settingsFormat.generate "generated-taler.conf" this.settings;
        in
        pkgs.runCommand "taler.conf" { } ''
          cat ${includes} > $out
          echo >> $out
          echo >> $out
          cat ${generatedConfig} >> $out
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
          # Should these be in here?
          # Should these even be configurable?
          PATHS = {
            TALER_DATA_HOME = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "\${STATE_DIRECTORY}/";
            };
            TALER_CACHE_HOME = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "\${CACHE_DIRECTORY}/";
            };
            TALER_RUNTIME_DIR = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "/run/taler-system-runtime/";
            };
          };
          taler = {
            CURRENCY = lib.mkOption {
              type = lib.types.str;
              default = throw "You must set `taler.CURRENCY` to your desired currency.";
              defaultText = "None, you must set this yourself.";
              description = ''
                The currency which taler services will operate with. This cannot be changed later.
              '';
            };
            CURRENCY_ROUND_UNIT = lib.mkOption {
              type = lib.types.str;
              default = "${this.settings.taler.CURRENCY}:0.01";
              defaultText = "0.01 in {option}`CURRENCY`";
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
  };

  config = lib.mkIf this.enable { environment.etc."taler/taler.conf".source = this.configFile; };
}
