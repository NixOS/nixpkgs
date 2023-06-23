{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.hardware.tiltfive;
in
{
  options.hardware.tiltfive = {
    enable = mkEnableOption (lib.mdDoc "tiltfive driver and service");

    user = mkOption {
      type = types.str;
      default = "tiltfive";
      description = lib.mdDoc "User account under which the Tilt Five driver service will run.";
    };

    group = mkOption {
      type = types.str;
      default = "tiltfive";
      description = lib.mdDoc "Group under which the Tilt Five driver service will run.";
    };

    dataDirectory = mkOption {
      type = types.path;
      default = "/var/lib/tiltfive";
      description = lib.mdDoc ''
        Directory where the Tilt Five service will store persistent data, eg.
        settings. Make sure it is writable.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tiltfive = {
      description = "Tilt Five Service";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tiltfive-driver}/bin/tiltfive-service";
        Restart = "always";
        RestartSec = 5;

        User = cfg.user;
        Group = cfg.group;

        Environment = [
          # The service does not run with telemetry enabled by default, but it
          # always attempts to create a telemetry database anyway.
          #
          # When not specified, the telemetry database defaults to being
          # installation-relative, so in our case it attempts to create the
          # telemetry database in the nix store. This will naturally fail.
          # Setting this environment variable makes it use a different location
          # for the database, leading to ugly startup errors.
          "TILTFIVE_TELEMDB=${cfg.dataDirectory}/telemdb"

          # Same deal for logs.
          "TILTFIVE_LOG=${cfg.dataDirectory}/log"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };

    # We don't use udev rules from the driver package as we want to be able to
    # customize the group which has access to the tiltfive devices (ie. the
    # group under which the driver service runs).
    services.udev.extraRules = ''
      # Tilt Five glasses
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="32f8", ATTRS{idProduct}=="9200", GROUP="${cfg.group}"

      # Tilt Five glasses (wrong speed)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="32f8", ATTRS{idProduct}=="2510", GROUP="${cfg.group}"

      # Tilt Five glasses bootloader
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="32f8", ATTRS{idProduct}=="424c", GROUP="${cfg.group}"
    '';

    users.users = mkIf (cfg.user == "tiltfive") {
      tiltfive = {
        group = cfg.group;
        home = cfg.dataDirectory;
        createHome = true;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.user == "tiltfive") {
      tiltfive = {};
    };

    environment.systemPackages = [
      pkgs.tiltfive-control-panel
    ];
  };
}
