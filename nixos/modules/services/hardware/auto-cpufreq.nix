{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.auto-cpufreq;
  cfgFilename = "auto-cpufreq.conf";
  cfgFile = format.generate cfgFilename cfg.settings;

  format = pkgs.formats.ini { };
in
{
  options = {
    services.auto-cpufreq = {
      enable = mkEnableOption "auto-cpufreq daemon";

      settings = mkOption {
        description = ''
          Configuration for `auto-cpufreq`.

          The available options can be found in [the example configuration file](https://github.com/AdnanHodzic/auto-cpufreq/blob/v${pkgs.auto-cpufreq.version}/auto-cpufreq.conf-example).
        '';

        default = { };
        type = types.submodule { freeformType = format.type; };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.auto-cpufreq ];

    systemd = {
      packages = [ pkgs.auto-cpufreq ];
      services.auto-cpufreq = {
        # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          bash
          coreutils
        ];

        serviceConfig.WorkingDirectory = "";
        serviceConfig.ExecStart = [
          ""
          "${lib.getExe pkgs.auto-cpufreq} --daemon --config ${cfgFile}"
        ];
      };
    };
  };

  # uses attributes of the linked package
  meta = {
    buildDocsInSandbox = false;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
