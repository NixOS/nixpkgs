{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  cfg = dmcfg.sddm;
  xEnv = config.systemd.services."display-manager".environment;

  xserverWrapper = pkgs.writeScript "xserver-wrapper" ''
    #!/bin/sh
    ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}
    exec ${dmcfg.xserverBin} ${dmcfg.xserverArgs} "$@"
  '';

  cfgFile = pkgs.writeText "sddm.conf" ''
    [General]
    HaltCommand=${pkgs.systemd}/bin/systemctl poweroff
    RebootCommand=${pkgs.systemd}/bin/systemctl reboot

    [Theme]
    Current=${cfg.theme}

    [Users]
    MaximumUid=${toString config.ids.uids.nixbld}
    HideUsers=${concatStringsSep "," dmcfg.hiddenUsers}
    HideShells=/run/current-system/sw/bin/nologin

    [XDisplay]
    MinimumVT=${toString xcfg.tty}
    ServerPath=${xserverWrapper}
    XephyrPath=${pkgs.xorg.xorgserver.out}/bin/Xephyr
    SessionCommand=${dmcfg.session.script}
    SessionDir=${dmcfg.session.desktops}
    XauthPath=${pkgs.xorg.xauth}/bin/xauth
  '';

in
{
  options = {

    services.xserver.displayManager.sddm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable sddm as the display manager.
        '';
      };

      theme = mkOption {
        type = types.str;
        default = "maui";
        description = ''
          Greeter theme to use.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job = {
      logsXsession = true;

      #execCmd = "${pkgs.sddm}/bin/sddm";
      execCmd = "exec ${pkgs.sddm}/bin/sddm";
    };

    security.pam.services = {
      sddm = {
        allowNullPassword = true;
        startSession = true;
      };

      sddm-greeter.text = ''
        auth     required       pam_succeed_if.so audit quiet_success user = sddm
        auth     optional       pam_permit.so

        account  required       pam_succeed_if.so audit quiet_success user = sddm
        account  sufficient     pam_unix.so

        password required       pam_deny.so

        session  required       pam_succeed_if.so audit quiet_success user = sddm
        session  required       pam_env.so envfile=${config.system.build.pamEnvironment}
        session  optional       ${pkgs.systemd}/lib/security/pam_systemd.so
        session  optional       pam_keyinit.so force revoke
        session  optional       pam_permit.so
      '';
    };

    users.extraUsers.sddm = {
      createHome = true;
      home = "/var/lib/sddm";
      group = "sddm";
      uid = config.ids.uids.sddm;
    };

    environment.etc."sddm.conf".source = cfgFile;

    users.extraGroups.sddm.gid = config.ids.gids.sddm;

  };
}
