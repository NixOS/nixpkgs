{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.displayManager.cosmic-greeter;
in
{
  meta.maintainers = with lib.maintainers; [ nyanbinary ];

  options.services.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption (lib.mdDoc "COSMIC greeter");
  };

  config = lib.mkIf cfg.enable {
    # greetd config
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = ''${pkgs.coreutils}/bin/env XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-greeter ${pkgs.cosmic-comp}/bin/cosmic-comp ${pkgs.cosmic-greeter}/bin/cosmic-greeter'';
        };
      };
    };

    # daemon for querying background state and such
    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.CosmicGreeter";
        ExecStart = "${pkgs.cosmic-greeter}/bin/cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    # greeter user (hardcoded in cosmic-greeter)
    systemd.tmpfiles.rules = [
      "d '/var/lib/cosmic-greeter' - cosmic-greeter cosmic-greeter - -"
    ];

    users.users.cosmic-greeter = {
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      group = "cosmic-greeter";
    };

    users.groups.cosmic-greeter = { };

    # required features
    hardware.${if lib.versionAtLeast lib.version "24.11" then "graphics" else "opengl"}.enable = true;
    services.libinput.enable = true;

    # required dbus services
    services.accounts-daemon.enable = true;

    # required for authentication
    security.pam.services.cosmic-greeter = { };

    # dbus definitions
    services.dbus.packages = with pkgs; [ cosmic-greeter ];
  };
}
