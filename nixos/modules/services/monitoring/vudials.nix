{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.vudials;
in
{
  options.services.vudials = {
    enable = mkEnableOption "VU Dials";

    user = mkOption {
      type = types.str;
      default = "vudials";
      description = "User account under which VU Dials runs.";
    };

    group = mkOption {
      type = types.str;
      default = "vudials";
      description = "Group under which VU Dials runs.";
    };

    port = mkOption {
      type = types.port;
      default = 5340;
      description = "Port on which VU Dials listens.";
    };

    cpudial = mkOption {
      type = types.str;
      default = "";
      description = "UID of the dial that will display CPU load";
    };

    gpudial = mkOption {
      type = types.str;
      default = "";
      description = "UID of the dial that will display GPU load";
    };

    memdial = mkOption {
      type = types.str;
      default = "";
      description = "UID of the dial that will display memory load";
    };

    dskdial = mkOption {
      type = types.str;
      default = "";
      description = "UID of the dial that will display % of the  disk space used on root partition";
    };

  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "VU Server user";
    };

    users.groups.${cfg.group} = { };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", ATTRS{serial}=="DQ0164KM", SYMLINK+="vuserver-$attr{serial}", TAG+="systemd", ENV{SYSTEMD_WANTS}="vuserver@$attr{serial}.service", MODE="0666"
      ACTION=="remove", SUBSYSTEM=="tty", ENV{ID_VENDOR_ID}=="0403", ENV{ID_MODEL_ID}=="6015", ENV{ID_SERIAL_SHORT}=="DQ0164KM", RUN+="${pkgs.systemd}/bin/systemctl stop vuserver@$env{ID_SERIAL_SHORT}.service"
    '';

    systemd.services."vuserver@" = {
      description = "VU Server for %I. Provides API, admin web page, and pushed updates to USB dials";
      partOf = [ "vuserver.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.vuserver}/bin/vuserver";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        WorkingDirectory = "${pkgs.vuserver}/lib";
        RuntimeDirectory = "vuserver";
        LogsDirectory = "vuserver";
        StateDirectory = "vuserver";
        TimeoutStopSec = "1s";

        Environment = [
          "STATEDIR=%S/vuserver"
          "LOGSDIR=%L/vuserver"
          "RUNTIMEDIR=%t/vuserver"
          "DEVICE=/dev/vuserver-%I"
          "PORT=${toString cfg.port}"
        ];
      };
    };

    systemd.targets.vuserver = { };

    systemd.services.vuclient = {
      enable = true;
      description = "Monitor computer and push info to VU server.";
      wantedBy = [ "multi-user.target" ];
      wants = [ "vuserver.target" ];
      after = [ "vuserver.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.vuclient}/bin/vuclient";
        TimeoutStopSec = "5s";
        Restart = "on-failure";
        Environment = [
          "CPUDIAL=${cfg.cpudial}"
          "GPUDIAL=${cfg.gpudial}"
          "MEMDIAL=${cfg.memdial}"
          "DSKDIAL=${cfg.dskdial}"
        ];
      };
    };

    powerManagement.powerDownCommands = lib.mkAfter ''
      systemctl stop vuclient.service
      sleep 1
    '';

    powerManagement.powerUpCommands = lib.mkAfter ''
      systemctl start vuclient.service
    '';

    environment.systemPackages = [ pkgs.vuserver ];
  };
}
