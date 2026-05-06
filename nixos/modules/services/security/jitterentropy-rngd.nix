{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.jitterentropy-rngd;
in
{
  options.services.jitterentropy-rngd = {
    enable = lib.mkEnableOption "jitterentropy-rngd service configuration";
    package = lib.mkPackageOption pkgs "jitterentropy-rngd" { };
    osr = lib.mkOption {
      type = lib.types.ints.between 3 20;
      default = 3;
      description = "Oversampling rate for jitterentropy (3 to 20)";
    };
    flags = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Additional flags to pass to jitterentropy";
    };
    forceSP800-90B = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Force SP800-90B mode for entropy reading";
    };
    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose log messages";
    };
  };

  config =
    let
      # use identical arguments for status and service execution,
      # in order to get meaningful output
      args =
        "--osr ${builtins.toString cfg.osr} --flags ${builtins.toString cfg.flags}"
        + lib.optionalString cfg.forceSP800-90B " --sp800-90b"
        + lib.optionalString cfg.verbose " -vvv";
    in
    lib.mkIf cfg.enable {
      systemd.packages = [ cfg.package ];
      systemd.services."jitterentropy".wantedBy = [ "basic.target" ];
      systemd.services."jitterentropy".serviceConfig = {
        # logs used configuration for comparison
        ExecStartPre = [
          "-${cfg.package}/bin/jitterentropy-rngd --status ${args}"
        ];
        ExecStart = [
          # clear old setting from built-in service file
          ""
          # use service from package with our configured args
          "${cfg.package}/bin/jitterentropy-rngd ${args}"
        ];
      };
    };

  meta.maintainers = with lib.maintainers; [ thillux ];
}
