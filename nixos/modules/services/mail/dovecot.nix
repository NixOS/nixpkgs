{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dovecot2;
  dovecotPkg = cfg.package;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  protocols = concatStrings [
    (optionalString cfg.enableImap "imap")
    (optionalString cfg.enablePop3 "pop3")
    (optionalString cfg.enableLmtp "lmtp")
  ];

  dovecotConf = concatStrings [
    ''
      base_dir = ${baseDir}
      protocols = ${protocols}
    ''

    (if isNull cfg.sslServerCert then ''
      ssl = no
      disable_plaintext_auth = no
    '' else ''
      ssl_cert = <${cfg.sslServerCert}
      ssl_key = <${cfg.sslServerKey}
      ${optionalString (!(isNull cfg.sslCACert)) ("ssl_ca = <" + cfg.sslCACert)}
      disable_plaintext_auth = yes
    '')

    ''
      default_internal_user = ${cfg.user}

      mail_location = ${cfg.mailLocation}

      maildir_copy_with_hardlinks = yes
      pop3_uidl_format = %08Xv%08Xu

      auth_mechanisms = plain login

      service auth {
        user = root
      }
    ''

    (optionalString cfg.enablePAM ''
      userdb {
        driver = passwd
      }

      passdb {
        driver = pam
        args = ${optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2
      }
    '')

    cfg.extraConfig
  ];

  modulesDir = pkgs.symlinkJoin "dovecot-modules"
    (map (module: "${module}/lib/dovecot") cfg.modules);

in
{

  options.services.dovecot2 = {
    enable = mkEnableOption "Dovecot 2.x POP3/IMAP server";

    enablePop3 = mkOption {
      type = types.bool;
      default = true;
      description = "Start the POP3 listener (when Dovecot is enabled).";
    };

    enableImap = mkOption {
      type = types.bool;
      default = true;
      description = "Start the IMAP listener (when Dovecot is enabled).";
    };

    enableLmtp = mkOption {
      type = types.bool;
      default = false;
      description = "Start the LMTP listener (when Dovecot is enabled).";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dovecot22;
      description = "Dovecot package to use.";
    };

    user = mkOption {
      type = types.str;
      default = "dovecot2";
      description = "Dovecot user name.";
    };

    group = mkOption {
      type = types.str;
      default = "dovecot2";
      description = "Dovecot group name.";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      example = "mail_debug = yes";
      description = "Additional entries to put verbatim into Dovecot's config file.";
    };

    configFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Config file used for the whole dovecot configuration.";
      apply = v: if v != null then v else pkgs.writeText "dovecot.conf" dovecotConf;
    };

    mailLocation = mkOption {
      type = types.str;
      default = "maildir:/var/spool/mail/%u"; /* Same as inbox, as postfix */
      example = "maildir:~/mail:INBOX=/var/spool/mail/%u";
      description = ''
        Location that dovecot will use for mail folders. Dovecot mail_location option.
      '';
    };

    modules = mkOption {
      type = types.listOf types.package;
      default = [];
      example = [ pkgs.dovecot_pigeonhole ];
      description = ''
        Symlinks the contents of lib/dovecot of every given package into
        /var/lib/dovecot/modules. This will make the given modules available
        if a dovecot package with the module_dir patch applied (like
        pkgs.dovecot22, the default) is being used.
      '';
    };

    sslCACert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to the server's CA certificate key.";
    };

    sslServerCert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to the server's public key.";
    };

    sslServerKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to the server's private key.";
    };

    enablePAM = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to create a own Dovecot PAM service and configure PAM user logins.";
    };

    showPAMFailure = mkOption {
      type = types.bool;
      default = false;
      description = "Show the PAM failure message on authentication error (useful for OTPW).";
    };
  };


  config = mkIf cfg.enable {

    security.pam.services.dovecot2 = mkIf cfg.enablePAM {};

    users.extraUsers = [
      { name = cfg.user;
        uid = config.ids.uids.dovecot2;
        description = "Dovecot user";
        group = cfg.group;
      }
      { name = "dovenull";
        uid = config.ids.uids.dovenull2;
        description = "Dovecot user for untrusted logins";
        group = cfg.group;
      }
    ];

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.dovecot2;
    };

    systemd.services.dovecot2 = {
      description = "Dovecot IMAP/POP3 server";

      after = [ "keys.target" "network.target" ];
      wants = [ "keys.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p "${baseDir}/login"
        chown -R ${cfg.user}:${cfg.group} "${baseDir}"
        rm -f "${stateDir}/modules"
        ln -s "${modulesDir}" "${stateDir}/modules"
      '';

      serviceConfig = {
        ExecStart = "${dovecotPkg}/sbin/dovecot -F -c ${cfg.configFile}";
        Restart = "on-failure";
        RestartSec = "1s";
        StartLimitInterval = "1min";
      };
    };

    environment.systemPackages = [ dovecotPkg ];

    assertions = [
      { assertion = cfg.enablePop3 || cfg.enableImap;
        message = "dovecot needs at least one of the IMAP or POP3 listeners enabled";
      }
      { assertion = isNull cfg.sslServerCert == isNull cfg.sslServerKey
          && (!(isNull cfg.sslCACert) -> !(isNull cfg.sslServerCert || isNull cfg.sslServerKey));
        message = "dovecot needs both sslServerCert and sslServerKey defined for working crypto";
      }
      { assertion = cfg.showPAMFailure -> cfg.enablePAM;
        message = "dovecot is configured with showPAMFailure while enablePAM is disabled";
      }
    ];

  };

}
