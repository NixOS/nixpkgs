{ config, pkgs, lib, utils, ... }:

with lib;

let
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules;

  mkModuleOptions = global: {
    rootOK = mkOption {
      type = types.bool;
      default = if global then false else modCfg.rootOK;
      description = ''
      If true, root doesn't need to authenticate (e.g. for the
      <command>useradd</command> service).
      '';
    };

    startSession = mkOption {
      default = if global then false else modCfg.startSession;
      type = types.bool;
      description = ''
        If set, the service will register a new session with
        systemd's login manager.  For local sessions, this will give
        the user access to audio devices, CD-ROM drives.  In the
        default PolicyKit configuration, it also allows the user to
        reboot the system.
      '';
    };

    setEnvironment = mkOption {
      type = types.bool;
      default = if global then true else modCfg.setEnvironment;
      description = ''
        Whether the service should set the environment variables
        listed in <option>environment.sessionVariables</option>
        using <literal>pam_env.so</literal>.
      '';
    };

    setLoginUid = mkOption {
      type = types.bool;
      default = if global then modCfg.startSession else modCfg.setLoginUid;
      description = ''
        Set the login uid of the process
        (<filename>/proc/self/loginuid</filename>) for auditing
        purposes.  The login uid is only set by ‘entry points’ like
        <command>login</command> and <command>sshd</command>, not by
        commands like <command>sudo</command>.
      '';
    };

    forwardXAuth = mkOption {
      default = if global then false else modCfg.forwardXAuth;
      type = types.bool;
      description = ''
        Whether X authentication keys should be passed from the
        calling user to the target user (e.g. for
        <command>su</command>)
      '';
    };

    requireWheel = mkOption {
      default = if global then false else modCfg.requireWheel;
      type = types.bool;
      description = ''
        Whether to permit root access only to members of group wheel.
      '';
    };

    updateWtmp = mkOption {
      default = if global then false else modCfg.updateWtmp;
      type = types.bool;
      description = "Whether to update <filename>/var/log/wtmp</filename>.";
    };

    logFailures = mkOption {
      default = if global then false else modCfg.logFailures;
      type = types.bool;
      description = ''
        Whether to log authentication failures in
        <filename>/var/log/faillog</filename>.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    deny = {
      control = "required";
      path = "pam_deny.so";
      order = 100000;
    };

    logFailures = mkIf svcCfg.modules.logFailures {
      control = "required";
      path = "pam_tally.so";
      order = 13000;
    };

    requireWheel = mkIf svcCfg.modules.requireWheel {
      control = "required";
      path = "pam_wheel.so";
      args = [ "use_uid" ];
      order = 12000;
    };

    rootOK = mkIf svcCfg.modules.rootOK {
      control = "sufficient";
      path = "pam_rootok.so";
      order = 11000;
    };
  };

  mkSessionConfig = svcCfg: {
    forwardXAuth = mkIf svcCfg.modules.forwardXAuth {
      control = "optional";
      path = "pam_xauth.so";
      args = [
        "xauthpath=${pkgs.xorg.xauth}/bin/xauth"
        "systemuser=99"
      ];
      order = 12000;
    };

    setEnvironment = mkIf svcCfg.modules.setEnvironment {
      control = "required";
      path = "pam_env.so";
      args = [
        "conffile=${config.system.build.pamEnvironment}"
        "readenv=0"
      ];
      order = 500;
    };

    setLoginUid = mkIf svcCfg.modules.setLoginUid {
      control = if config.boot.isContainer then "optional" else "required";
      path = "pam_loginuid.so";
      order = 2000;
    };

    startSession = mkIf svcCfg.modules.startSession {
      control = "optional";
      path = "${pkgs.systemd}/lib/security/pam_systemd.so";
      order = 11000;
    };

    updateWtmp = mkIf svcCfg.modules.updateWtmp {
      control = "required";
      path = "${pkgs.pam}/lib/security/pam_lastlog.so";
      args = [ "silent" ];
      order = 4000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      # Those options should be directly under the modules option and not
      # grouped under a name.
      name = null;
      inherit mkModuleOptions mkAuthConfig mkSessionConfig;
      extraSubmodules = [(
        { config, ... }: {
          config = {
            modules.setLoginUid = mkDefault config.modules.startSession;
          };
        }
      )];
    };
  };

  imports = [
    ./ecryptfs.nix
    ./gnome-keyring.nix
    ./gnupg.nix
    ./google-authenticator.nix
    ./kwallet.nix
    ./limits.nix
    ./make-home-dir.nix
    ./motd.nix
    ./oath.nix
    ./otpw.nix
    ./p11.nix
    ./pam_mount.nix
    ./ssh-agent.nix
    ./u2f.nix
    ./unix.nix
    ./usb.nix
    ./yubico.nix
  ];
}
