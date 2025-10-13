# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager.cosmic-greeter;
  cfgAutoLogin = config.services.displayManager.autoLogin;
in

{
  meta.maintainers = lib.teams.cosmic.members;

  options.services.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption "COSMIC greeter";
    package = lib.mkPackageOption pkgs "cosmic-greeter" { };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" ${lib.getExe' cfg.package "cosmic-greeter-start"}'';
        };
        initial_session = lib.mkIf (cfgAutoLogin.enable && (cfgAutoLogin.user != null)) {
          user = cfgAutoLogin.user;
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-session ${lib.getExe' pkgs.cosmic-session "start-cosmic"}'';
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
        ExecStart = lib.getExe' cfg.package "cosmic-greeter-daemon";
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
    # Required for authentication
    security.pam.services.cosmic-greeter = { };

    hardware.graphics.enable = true;
    services.accounts-daemon.enable = true;
    services.dbus.packages = [ cfg.package ];
    services.libinput.enable = true;
  };
}
