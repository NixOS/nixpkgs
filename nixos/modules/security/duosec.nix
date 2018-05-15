{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.duosec;

  boolToStr = b: if b then "yes" else "no";

  configFile = ''
    [duo]
    ikey=${cfg.ikey}
    skey=${cfg.skey}
    host=${cfg.host}
    ${optionalString (cfg.group != "") ("group="+cfg.group)}
    failmode=${cfg.failmode}
    pushinfo=${boolToStr cfg.pushinfo}
    autopush=${boolToStr cfg.autopush}
    motd=${boolToStr cfg.motd}
    prompts=${toString cfg.prompts}
    accept_env_factor=${boolToStr cfg.acceptEnvFactor}
    fallback_local_ip=${boolToStr cfg.fallbackLocalIP}
  '';

  loginCfgFile = optional cfg.ssh.enable
    { source = pkgs.writeText "login_duo.conf" configFile;
      mode   = "0600";
      user   = "sshd";
      target = "duo/login_duo.conf";
    };

  pamCfgFile = optional cfg.pam.enable
    { source = pkgs.writeText "pam_duo.conf" configFile;
      mode   = "0600";
      user   = "sshd";
      target = "duo/pam_duo.conf";
    };
in
{
  options = {
    security.duosec = {
      ssh.enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, protect SSH logins with Duo Security.";
      };

      pam.enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, protect logins with Duo Security using PAM support.";
      };

      ikey = mkOption {
        type = types.str;
        description = "Integration key.";
      };

      skey = mkOption {
        type = types.str;
        description = "Secret key.";
      };

      host = mkOption {
        type = types.str;
        description = "Duo API hostname.";
      };

      group = mkOption {
        type = types.str;
        default = "";
        description = "Use Duo authentication for users only in this group.";
      };

      failmode = mkOption {
        type = types.enum [ "safe" "enum" ];
        default = "safe";
        description = ''
          On service or configuration errors that prevent Duo
          authentication, fail "safe" (allow access) or "secure" (deny
          access). The default is "safe".
        '';
      };

      pushinfo = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Include information such as the command to be executed in
          the Duo Push message.
        '';
      };

      autopush = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If <literal>true</literal>, Duo Unix will automatically send
          a push login request to the user’s phone, falling back on a
          phone call if push is unavailable. If
          <literal>false</literal>, the user will be prompted to
          choose an authentication method. When configured with
          <literal>autopush = yes</literal>, we recommend setting
          <literal>prompts = 1</literal>.
        '';
      };

      motd = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Print the contents of <literal>/etc/motd</literal> to screen
          after a successful login.
        '';
      };

      prompts = mkOption {
        type = types.enum [ 1 2 3 ];
        default = 3;
        description = ''
          If a user fails to authenticate with a second factor, Duo
          Unix will prompt the user to authenticate again. This option
          sets the maximum number of prompts that Duo Unix will
          display before denying access. Must be 1, 2, or 3. Default
          is 3.

          For example, when <literal>prompts = 1</literal>, the user
          will have to successfully authenticate on the first prompt,
          whereas if <literal>prompts = 2</literal>, if the user
          enters incorrect information at the initial prompt, he/she
          will be prompted to authenticate again.

          When configured with <literal>autopush = true</literal>, we
          recommend setting <literal>prompts = 1</literal>.
        '';
      };

      acceptEnvFactor = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Look for factor selection or passcode in the
          <literal>$DUO_PASSCODE</literal> environment variable before
          prompting the user for input.

          When $DUO_PASSCODE is non-empty, it will override
          autopush. The SSH client will need SendEnv DUO_PASSCODE in
          its configuration, and the SSH server will similarly need
          AcceptEnv DUO_PASSCODE.
        '';
      };

      fallbackLocalIP = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Duo Unix reports the IP address of the authorizing user, for
          the purposes of authorization and whitelisting. If Duo Unix
          cannot detect the IP address of the client, setting
          <literal>fallbackLocalIP = yes</literal> will cause Duo Unix
          to send the IP address of the server it is running on.

          If you are using IP whitelisting, enabling this option could
          cause unauthorized logins if the local IP is listed in the
          whitelist.
        '';
      };

      allowTcpForwarding = mkOption {
        type = types.bool;
        default = false;
        description = ''
          By default, when SSH forwarding, enabling Duo Security will
          disable TCP forwarding. By enabling this, you potentially
          undermine some of the SSH based login security. Note this is
          not needed if you use PAM.
        '';
      };
    };
  };

  config = mkIf (cfg.ssh.enable || cfg.pam.enable) {
    assertions =
      [ { assertion = !cfg.pam.enable;
          message   = "PAM support is currently not implemented.";
        }
      ];

     environment.systemPackages = [ pkgs.duo-unix ];

     security.wrappers.login_duo.source = "${pkgs.duo-unix.out}/bin/login_duo";
     environment.etc = loginCfgFile ++ pamCfgFile;

     /* If PAM *and* SSH are enabled, then don't do anything special.
     If PAM isn't used, set the default SSH-only options. */
     services.openssh.extraConfig = mkIf (cfg.ssh.enable || cfg.pam.enable) (
     if cfg.pam.enable then "UseDNS no" else ''
       # Duo Security configuration
       ForceCommand ${config.security.wrapperDir}/login_duo
       PermitTunnel no
       ${optionalString (!cfg.allowTcpForwarding) ''
         AllowTcpForwarding no
       ''}
     '');
  };
}
