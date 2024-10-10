{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ryzen-ppd;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "ryzen-ppd.ini" cfg.config;
in
{
  options = {
    programs.ryzen-ppd = {
      enable = lib.mkEnableOption "Power management daemon for AMD Ryzen Mobile processors.";
      package = lib.mkPackageOption pkgs "ryzen-ppd" { };
      config = lib.mkOption {
        type = lib.types.submodule { freeformType = settingsFormat.type; };
        description = "Configurationn file in INI format";
        default = lib.mkDefault {
          ryzenadj = {
            limits = ''["stapm_limit", "fast_limit", "slow_limit", "apu_slow_limit", "tctl_temp", "apu_skin_temp_limit"]'';
            monitor = "stapm_limit";
          };
          profiles = {
            battery = ''[ 11000,  8800,  8800, 12000, 70, 45 ]'';
            low-power = ''[ 11000,  9900,  9900, 13500, 70, 45 ]'';
            balanced = ''[ 20000, 20000, 15000, 15000, 86, 45 ]'';
            performance = ''[ 25000, 25000, 23000, 15000, 96, 53 ]'';
            custom = ''[ 30000, 30000, 28000, 17000, 96, 64 ]'';
          };
          ac = {
            profile = "balanced";
            update_rate_s = 4;
          };
          battery = {
            profile = "low-power";
            update_rate_s = 32;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ryzen-ppd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "dbus.service" ];
      description = "Power management daemon for AMD Ryzen Mobile processors.";
      enable = true;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getBin cfg.package}/bin/ryzen-ppd --config /etc/ryzen-ppd.ini";
        Environment = "PYTHONUNBUFFERED=1";
      };
    };
    environment = {
      systemPackages = [
        cfg.package
        pkgs.ryzenadj
      ];
      etc."ryzen-ppd.ini".source = configFile;
    };
    hardware.cpu.amd.ryzen-smu.enable = true;
  };

  meta.maintainers = with lib.maintainers; [ SohamG ];
}
