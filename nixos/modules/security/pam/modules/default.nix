{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules;

  moduleOptions = global: {
    rootOK = mkOption {
      type = types.bool;
      default = if global then false else cfg.rootOK;
      description = ''
      If true, root doesn't need to authenticate (e.g. for the
      <command>useradd</command> service).
      '';
    };

    startSession = mkOption {
      default = if global then false else cfg.startSession;
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
      default = if global then true else cfg.setEnvironment;
      description = ''
        Whether the service should set the environment variables
        listed in <option>environment.sessionVariables</option>
        using <literal>pam_env.so</literal>.
      '';
    };

    setLoginUid = mkOption {
      type = types.bool;
      default = if global then cfg.startSession else cfg.setLoginUid;
      description = ''
        Set the login uid of the process
        (<filename>/proc/self/loginuid</filename>) for auditing
        purposes.  The login uid is only set by ‘entry points’ like
        <command>login</command> and <command>sshd</command>, not by
        commands like <command>sudo</command>.
      '';
    };

    forwardXAuth = mkOption {
      default = if global then false else cfg.forwardXAuth;
      type = types.bool;
      description = ''
        Whether X authentication keys should be passed from the
        calling user to the target user (e.g. for
        <command>su</command>)
      '';
    };

    requireWheel = mkOption {
      default = if global then false else cfg.requireWheel;
      type = types.bool;
      description = ''
        Whether to permit root access only to members of group wheel.
      '';
    };

    updateWtmp = mkOption {
      default = if global then false else cfg.updateWtmp;
      type = types.bool;
      description = "Whether to update <filename>/var/log/wtmp</filename>.";
    };

    logFailures = mkOption {
      default = if global then false else cfg.logFailures;
      type = types.bool;
      description = ''
        Whether to log authentication failures in
        <filename>/var/log/faillog</filename>.
      '';
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules = moduleOptions false;
            };

            config = {
              modules.setLoginUid = mkDefault config.modules.startSession;

              auth = mkDefault {
                deny = {
                  control = "required";
                  path = "pam_deny.so";
                  order = 100000;
                };

                logFailures = mkIf config.modules.logFailures {
                  control = "required";
                  path = "pam_tally.so";
                  order = 13000;
                };

                requireWheel = mkIf config.modules.requireWheel {
                  control = "required";
                  path = "pam_wheel.so";
                  args = [ "use_uid" ];
                  order = 12000;
                };

                rootOK = mkIf config.modules.rootOK {
                  control = "sufficient";
                  path = "pam_rootok.so";
                  order = 11000;
                };
              };

              session = mkDefault {
                forwardXAuth = mkIf config.modules.forwardXAuth {
                  control = "optional";
                  path = "pam_xauth.so";
                  args = [
                    "xauthpath=${pkgs.xorg.xauth}/bin/xauth"
                    "systemuser=99"
                  ];
                  order = 12000;
                };

                setEnvironment = mkIf config.modules.setEnvironment {
                  control = "required";
                  path = "pam_env.so";
                  args = [
                    "conffile=${topCfg.system.build.pamEnvironment}"
                    "readenv=0"
                  ];
                  order = 500;
                };

                setLoginUid = mkIf config.modules.setLoginUid {
                  control = if topCfg.boot.isContainer then "optional" else "required";
                  path = "pam_loginuid.so";
                  order = 2000;
                };

                startSession = mkIf config.modules.startSession {
                  control = "optional";
                  path = "${pkgs.systemd}/lib/security/pam_systemd.so";
                  order = 11000;
                };

                updateWtmp = mkIf config.modules.updateWtmp {
                  control = "required";
                  path = "${pkgs.pam}/lib/security/pam_lastlog.so";
                  args = [ "silent" ];
                  order = 4000;
                };
              };
            };
          })
        );
      };

      modules = moduleOptions true;
    };
  };

  imports = [
   ./app-armor.nix
   ./duo-security.nix
   ./ecryptfs.nix
   ./fprintd.nix
   ./gnome-keyring.nix
   ./gnupg.nix
   ./google-authenticator.nix
   ./google-os-login.nix
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
