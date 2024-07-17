{
  lib,
  pkgs,
  config,
  ...
}:

let
  this = config.services.taler;
  settingsFormat = pkgs.formats.ini { };
in

{
  options.services.taler.settings = lib.mkOption {
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
}
