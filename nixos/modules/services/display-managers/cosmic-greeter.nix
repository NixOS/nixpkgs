{ config, lib, pkgs, ... }:

{
  meta.maintainers = with lib.maintainers; [
    thefossguy
  ];

  options.services.displayManager.cosmic-greeter.enable = lib.mkEnableOption "COSMIC greeter";

  config = lib.mkIf config.services.displayManager.cosmic-greeter.enable {
    services.greetd = {
      enable = lib.mkDefault true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-greeter ${lib.getExe pkgs.cosmic-comp} ${lib.getExe pkgs.cosmic-greeter}'';
        };
      };
    };

    # Daemon for querying background state and such
    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.CosmicGreeter";
        ExecStart = lib.getExe' pkgs.cosmic-greeter "cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    # The greeter user is hardcoded in `cosmic-greeter`
    users.groups.cosmic-greeter = { };
    users.users.cosmic-greeter = {
      description = "COSMIC login greeter user";
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      createHome = true;
      group = "cosmic-greeter";
    };

    hardware.graphics.enable = true;
    security.pam.services.cosmic-greeter = { };
    services.accounts-daemon.enable = true;
    services.dbus.packages = with pkgs; [ cosmic-greeter ];
    services.libinput.enable = true;
  };
}
