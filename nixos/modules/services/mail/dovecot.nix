{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dovecot2;
  dovecotPkg = pkgs.dovecot;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  dovecotConf = concatStrings [
    ''
      base_dir = ${baseDir}
      protocols = ${concatStringsSep " " cfg.protocols}
      sendmail_path = /run/wrappers/bin/sendmail
      # defining mail_plugins must be done before the first protocol {} filter because of https://doc.dovecot.org/configuration_manual/config_file/config_file_syntax/#variable-expansion
      mail_plugins = $mail_plugins ${concatStringsSep " " cfg.mailPlugins.globally.enable}
    ''

    (
      concatStringsSep "\n" (
        mapAttrsToList (
          protocol: plugins: ''
            protocol ${protocol} {
              mail_plugins = $mail_plugins ${concatStringsSep " " plugins.enable}
            }
          ''
        ) cfg.mailPlugins.perProtocol
      )
    )

    (
      if cfg.sslServerCert == null then ''
        ssl = no
        disable_plaintext_auth = no
      '' else ''
        ssl_cert = <${cfg.sslServerCert}
        ssl_key = <${cfg.sslServerKey}
        ${optionalString (cfg.sslCACert != null) ("ssl_ca = <" + cfg.sslCACert)}
        ${optionalString cfg.enableDHE ''ssl_dh = <${config.security.dhparams.params.dovecot2.path}''}
        disable_plaintext_auth = yes
      ''
    )

    ''
      default_internal_user = ${cfg.user}
      default_internal_group = ${cfg.group}
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

    (
      optionalString cfg.enablePAM ''
        userdb {
          driver = passwd
        }

        passdb {
          driver = pam
          args = ${optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2
        }
      ''
    )

    (
      optionalString (cfg.sieveScripts != {}) ''
        plugin {
          ${concatStringsSep "\n" (mapAttrsToList (to: from: "sieve_${to} = ${stateDir}/sieve/${to}") cfg.sieveScripts)}
        }
      ''
    )

    (
      optionalString (cfg.mailboxes != {}) ''
        namespace inbox {
          inbox=yes
          ${concatStringsSep "\n" (map mailboxConfig (attrValues cfg.mailboxes))}
        }
      ''
    )

    (
      optionalString cfg.enableQuota ''
        service quota-status {
          executable = ${dovecotPkg}/libexec/dovecot/quota-status -p postfix
          inet_listener {
            port = ${cfg.quotaPort}
          }
          client_limit = 1
        }

        plugin {
          quota_rule = *:storage=${cfg.quotaGlobalPerUser}
          quota = count:User quota # per virtual mail user quota
          quota_status_success = DUNNO
          quota_status_nouser = DUNNO
          quota_status_overquota = "552 5.2.2 Mailbox is full"
          quota_grace = 10%%
          quota_vsizes = yes
        }
      ''
    )

    cfg.extraConfig
  ];

  modulesDir = pkgs.symlinkJoin {
    name = "dovecot-modules";
    paths = map (pkg: "${pkg}/lib/dovecot") ([ dovecotPkg ] ++ map (module: module.override { dovecot = dovecotPkg; }) cfg.modules);
  };

  mailboxConfig = mailbox: ''
    mailbox "${mailbox.name}" {
      auto = ${toString mailbox.auto}
  '' + optionalString (mailbox.autoexpunge != null) ''
    autoexpunge = ${mailbox.autoexpunge}
  '' + optionalString (mailbox.specialUse != null) ''
    special_use = \${toString mailbox.specialUse}
  '' + "}";

  mailboxes = { name, ... }: {
    options = {
      name = mkOption {
        type = types.strMatching ''[^"]+'';
        example = "Spam";
        default = name;
        readOnly = true;
        description = "The name of the mailbox.";
      };
      auto = mkOption {
        type = types.enum [ "no" "create" "subscribe" ];
        default = "no";
        example = "subscribe";
        description = "Whether to automatically create or create and subscribe to the mailbox or not.";
      };
      specialUse = mkOption {
        type = types.nullOr (types.enum [ "All" "Archive" "Drafts" "Flagged" "Junk" "Sent" "Trash" ]);
        default = null;
        example = "Junk";
        description = "Null if no special use flag is set. Other than that every use flag mentioned in the RFC is valid.";
      };
      autoexpunge = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "60d";
        description = ''
          To automatically remove all email from the mailbox which is older than the
          specified time.
        '';
      };
    };
  };
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "dovecot2" "package" ] "")
  ];

  options.services.dovecot2 = {
    enable = mkEnableOption "the dovecot 2.x POP3/IMAP server";

    enablePop3 = mkEnableOption "starting the POP3 listener (when Dovecot is enabled).";

    enableImap = mkEnableOption "starting the IMAP listener (when Dovecot is enabled)." // { default = true; };

    enableLmtp = mkEnableOption "starting the LMTP listener (when Dovecot is enabled).";

    protocols = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional listeners to start when Dovecot is enabled.";
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
      type = types.lines;
      default = "";
      example = "mail_debug = yes";
      description = "Additional entries to put verbatim into Dovecot's config file.";
    };

    mailPlugins =
      let
        plugins = hint: types.submodule {
          options = {
            enable = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "mail plugins to enable as a list of strings to append to the ${hint} <literal>$mail_plugins</literal> configuration variable";
            };
          };
        };
      in
        mkOption {
          type = with types; submodule {
            options = {
              globally = mkOption {
                description = "Additional entries to add to the mail_plugins variable for all protocols";
                type = plugins "top-level";
                example = { enable = [ "virtual" ]; };
                default = { enable = []; };
              };
              perProtocol = mkOption {
                description = "Additional entries to add to the mail_plugins variable, per protocol";
                type = attrsOf (plugins "corresponding per-protocol");
                default = {};
                example = { imap = [ "imap_acl" ]; };
              };
            };
          };
          description = "Additional entries to add to the mail_plugins variable, globally and per protocol";
          example = {
            globally.enable = [ "acl" ];
            perProtocol.imap.enable = [ "imap_acl" ];
          };
          default = { globally.enable = []; perProtocol = {}; };
        };

    configFile = mkOption {
      type = types.nullOr types.path;
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

    createMailUser = mkEnableOption ''automatically creating the user
      given in <option>services.dovecot.user</option> and the group
      given in <option>services.dovecot.group</option>.'' // { default = true; };

    modules = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.dovecot_pigeonhole ]";
      description = ''
        Symlinks the contents of lib/dovecot of every given package into
        /etc/dovecot/modules. This will make the given modules available
        if a dovecot package with the module_dir patch applied is being used.
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

    enablePAM = mkEnableOption "creating a own Dovecot PAM service and configure PAM user logins." // { default = true; };

    enableDHE = mkEnableOption "enable ssl_dh and generation of primes for the key exchange." // { default = true; };

    sieveScripts = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = "Sieve scripts to be executed. Key is a sequence, e.g. 'before2', 'after' etc.";
    };

    showPAMFailure = mkEnableOption "showing the PAM failure message on authentication error (useful for OTPW).";

    mailboxes = mkOption {
      type = with types; coercedTo
        (listOf unspecified)
        (list: listToAttrs (map (entry: { name = entry.name; value = removeAttrs entry ["name"]; }) list))
        (attrsOf (submodule mailboxes));
      default = {};
      example = literalExpression ''
        {
          Spam = { specialUse = "Junk"; auto = "create"; };
        }
      '';
      description = "Configure mailboxes and auto create or subscribe them.";
    };

    enableQuota = mkEnableOption "the dovecot quota service.";

    quotaPort = mkOption {
      type = types.str;
      default = "12340";
      description = ''
        The Port the dovecot quota service binds to.
        If using postfix, add check_policy_service inet:localhost:12340 to your smtpd_recipient_restrictions in your postfix config.
      '';
    };
    quotaGlobalPerUser = mkOption {
      type = types.str;
      default = "100G";
      example = "10G";
      description = "Quota limit for the user in bytes. Supports suffixes b, k, M, G, T and %.";
    };

  };


  config = mkIf cfg.enable {
    security.pam.services.dovecot2 = mkIf cfg.enablePAM {};

    security.dhparams = mkIf (cfg.sslServerCert != null && cfg.enableDHE) {
      enable = true;
      params.dovecot2 = {};
    };
    services.dovecot2.protocols =
      optional cfg.enableImap "imap"
      ++ optional cfg.enablePop3 "pop3"
      ++ optional cfg.enableLmtp "lmtp";

    services.dovecot2.mailPlugins = mkIf cfg.enableQuota {
      globally.enable = [ "quota" ];
      perProtocol.imap.enable = [ "imap_quota" ];
    };

    users.users = {
      dovenull =
        {
          uid = config.ids.uids.dovenull2;
          description = "Dovecot user for untrusted logins";
          group = "dovenull";
        };
    } // optionalAttrs (cfg.user == "dovecot2") {
      dovecot2 =
        {
          uid = config.ids.uids.dovecot2;
          description = "Dovecot user";
          group = cfg.group;
        };
    } // optionalAttrs (cfg.createMailUser && cfg.mailUser != null) {
      ${cfg.mailUser} =
        { description = "Virtual Mail User"; isSystemUser = true; } // optionalAttrs (cfg.mailGroup != null)
          { group = cfg.mailGroup; };
    };

    users.groups = {
      dovenull.gid = config.ids.gids.dovenull2;
    } // optionalAttrs (cfg.group == "dovecot2") {
      dovecot2.gid = config.ids.gids.dovecot2;
    } // optionalAttrs (cfg.createMailUser && cfg.mailGroup != null) {
      ${cfg.mailGroup} = {};
    };

    environment.etc."dovecot/modules".source = modulesDir;
    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot2 = {
      description = "Dovecot IMAP/POP3 server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ cfg.configFile modulesDir ];

      startLimitIntervalSec = 60;  # 1 min
      serviceConfig = {
        Type = "notify";
        ExecStart = "${dovecotPkg}/sbin/dovecot -F";
        ExecReload = "${dovecotPkg}/sbin/doveadm reload";
        Restart = "on-failure";
        RestartSec = "1s";
        RuntimeDirectory = [ "dovecot2" ];
      };

      # When copying sieve scripts preserve the original time stamp
      # (should be 0) so that the compiled sieve script is newer than
      # the source file and Dovecot won't try to compile it.
      preStart = ''
        rm -rf ${stateDir}/sieve
      '' + optionalString (cfg.sieveScripts != {}) ''
        mkdir -p ${stateDir}/sieve
        ${concatStringsSep "\n" (
        mapAttrsToList (
          to: from: ''
            if [ -d '${from}' ]; then
              mkdir '${stateDir}/sieve/${to}'
              cp -p "${from}/"*.sieve '${stateDir}/sieve/${to}'
            else
              cp -p '${from}' '${stateDir}/sieve/${to}'
            fi
            ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/sieve/${to}'
          ''
        ) cfg.sieveScripts
      )}
        chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/sieve'
      '';
    };

    environment.systemPackages = [ dovecotPkg ];

    warnings = mkIf (any isList options.services.dovecot2.mailboxes.definitions) [
      "Declaring `services.dovecot2.mailboxes' as a list is deprecated and will break eval in 21.05! See the release notes for more info for migration."
    ];

    assertions = [
      {
        assertion = (cfg.sslServerCert == null) == (cfg.sslServerKey == null)
        && (cfg.sslCACert != null -> !(cfg.sslServerCert == null || cfg.sslServerKey == null));
        message = "dovecot needs both sslServerCert and sslServerKey defined for working crypto";
      }
      {
        assertion = cfg.showPAMFailure -> cfg.enablePAM;
        message = "dovecot is configured with showPAMFailure while enablePAM is disabled";
      }
      {
        assertion = cfg.sieveScripts != {} -> (cfg.mailUser != null && cfg.mailGroup != null);
        message = "dovecot requires mailUser and mailGroup to be set when sieveScripts is set";
      }
    ];

  };

}
