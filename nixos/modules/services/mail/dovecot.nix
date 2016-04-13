{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dovecot2;
  dovecotPkg = cfg.package;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  dovecotConf = concatStrings [
    ''
      base_dir = ${baseDir}
      protocols = ${concatStringsSep " " cfg.protocols}
      sendmail_path = /var/setuid-wrappers/sendmail
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
      ${optionalString (cfg.mailUser != null) "mail_uid = ${cfg.mailUser}"}
      ${optionalString (cfg.mailGroup != null) "mail_gid = ${cfg.mailGroup}"}

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

    (optionalString (cfg.sieveScripts != {}) ''
      plugin {
        ${concatStringsSep "\n" (mapAttrsToList (to: from: "sieve_${to} = ${stateDir}/sieve/${to}") cfg.sieveScripts)}
      }
    '')

    cfg.extraConfig
  ];

  modulesDir = pkgs.symlinkJoin "dovecot-modules"
    (map (pkg: "${pkg}/lib/dovecot") ([ dovecotPkg ] ++ map (module: module.override { dovecot = dovecotPkg; }) cfg.modules));

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

    protocols = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional listeners to start when Dovecot is enabled.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dovecot;
      defaultText = "pkgs.dovecot";
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

    mailUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default user to store mail for virtual users.";
    };

    mailGroup = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Default group to store mail for virtual users.";
    };

    modules = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "[ pkgs.dovecot_pigeonhole ]";
      description = ''
        Symlinks the contents of lib/dovecot of every given package into
        /etc/dovecot/modules. This will make the given modules available
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
      description = "Whether to create a own Dovecot PAM service and configure PAM user logins.";
    };

    sieveScripts = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = "Sieve scripts to be executed. Key is a sequence, e.g. 'before2', 'after' etc.";
    };

    showPAMFailure = mkOption {
      type = types.bool;
      default = false;
      description = "Show the PAM failure message on authentication error (useful for OTPW).";
    };
  };


  config = mkIf cfg.enable {

    security.pam.services.dovecot2 = mkIf cfg.enablePAM {};

    services.dovecot2.protocols =
     optional cfg.enableImap "imap"
     ++ optional cfg.enablePop3 "pop3"
     ++ optional cfg.enableLmtp "lmtp";

    users.extraUsers = [
      { name = "dovenull";
        uid = config.ids.uids.dovenull2;
        description = "Dovecot user for untrusted logins";
        group = cfg.group;
      }
    ] ++ optional (cfg.user == "dovecot2")
         { name = "dovecot2";
           uid = config.ids.uids.dovecot2;
           description = "Dovecot user";
           group = cfg.group;
         };

    users.extraGroups = optional (cfg.group == "dovecot2")
      { name = "dovecot2";
        gid = config.ids.gids.dovecot2;
      };

    environment.etc."dovecot/modules".source = modulesDir;
    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot2 = {
      description = "Dovecot IMAP/POP3 server";

      after = [ "keys.target" "network.target" ];
      wants = [ "keys.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ cfg.configFile ];

      serviceConfig = {
        ExecStart = "${dovecotPkg}/sbin/dovecot -F";
        ExecReload = "${dovecotPkg}/sbin/doveadm reload";
        Restart = "on-failure";
        RestartSec = "1s";
        StartLimitInterval = "1min";
        RuntimeDirectory = [ "dovecot2" ];
      };

      preStart = ''
        rm -rf ${stateDir}/sieve
      '' + optionalString (cfg.sieveScripts != {}) ''
        mkdir -p ${stateDir}/sieve
        ${concatStringsSep "\n" (mapAttrsToList (to: from: ''
          if [ -d '${from}' ]; then
            mkdir '${stateDir}/sieve/${to}'
            cp "${from}/"*.sieve '${stateDir}/sieve/${to}'
          else
            cp '${from}' '${stateDir}/sieve/${to}'
          fi
           ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/sieve/${to}'
        '') cfg.sieveScripts)}
        chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/sieve'
      '';
    };

    environment.systemPackages = [ dovecotPkg ];

    assertions = [
      { assertion = intersectLists cfg.protocols [ "pop3" "imap" ] != [];
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
