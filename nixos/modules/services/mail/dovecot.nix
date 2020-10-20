{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dovecot2;
  dovecotPkg = pkgs.dovecot;

  baseDir = "/run/dovecot2";

  sieveToPath = text:
    # Sieve scripts can start with a block comment
    if isString text && hasPrefix "/*" text
      then pkgs.writeText "script.sieve" text
    # Paths in the store are used as is
    else if types.path.check text && hasPrefix "${builtins.storeDir}/" (toString text)
      then text
    # Paths outside the store get written to the store
    else if types.path.check text
      then pkgs.writeText "script.sieve" (fileContents text)
    # All other is assumed to be file content
    else pkgs.writeText "script.sieve" text;
  scriptType = types.coercedTo types.lines sieveToPath types.path;

  compileSieveScripts = pkgs.buildSieveScripts {
    name = "dovecot2-sieveScripts";
      plugins = cfg.sieve.plugins;
      extensions = cfg.sieve.extensions;
      globalExtensions = cfg.sieve.globalExtensions;
      dontUnpack = true;
      dontConfigure = true;
      buildPhase = ''
        mkdir sieve
        cd sieve
        ${concatStringsSep "\n" (imap1 (i: v: ''
          if [ -d '${v}' ]; then
            ln -s '${v}' after/${toString i}
          else
            mkdir -p after/${toString i}
            ln -s '${v}' after/${toString i}/default.sieve
          fi
        '') cfg.sieve.afterScripts)}
        ${concatStringsSep "\n" (imap1 (i: v: ''
          if [ -d '${v}' ]; then
            ln -s '${v}' before/${toString i}
          else
            mkdir -p before/${toString i}
            ln -s '${v}' before/${toString i}/default.sieve
          fi
        '') cfg.sieve.beforeScripts)}
        ${optionalString (cfg.sieve.defaultScript != null) ''
          ln -s '${cfg.sieve.defaultScript}' default.sieve
        ''}
        ${optionalString (cfg.sieve.discardScript != null) ''
          ln -s '${cfg.sieve.discardScript}' discard.sieve
        ''}
        ${concatStringsSep "\n" (imap1 (i: mb: ''
          mkdir -p imapsieve/${toString i}
          ${optionalString (mb.before != null)''
            ln -s '${mb.before}' imapsieve/${toString i}/before.sieve
          ''}
          ${optionalString (mb.after != null)''
            ln -s '${mb.after}' imapsieve/${toString i}/after.sieve
          ''}
        '') cfg.sieve.imapsieve.mailboxes)}
      '';
  };

  listOfScripts = type: idx: config:
    let indexName = optionalString (idx > 1) (toString idx);
        value = config.services.dovecot2.sieveScripts."${type}${indexName}" or "";
    in optionals (hasPrefix "/" (toString value))
        ([value] ++ (listOfScripts type (idx + 1) config));

  mapScripts = type: scripts:
    (imap1
      (i: v: "sieve_${type}${optionalString (i != 1) (toString i)} = ${compileSieveScripts}/sieve/${type}/${toString i}")
      scripts);

  mapImapScripts = mailboxes:
    (imap1
      (i: mb: ''
        imapsieve_mailbox${toString i}_name = ${mb.name}
        ${optionalString (mb.before != null) ''
          imapsieve_mailbox${toString i}_before = ${compileSieveScripts}/sieve/imapsieve/${toString i}/before.sieve"
        ''}
        ${optionalString (mb.after != null) ''
          imapsieve_mailbox${toString i}_after = ${compileSieveScripts}/sieve/imapsieve/${toString i}/after.sieve"
        ''}
        ${optionalString (mb.from != null) ''
          imapsieve_mailbox${toString i}_from = ${mb.from}
        ''}
        ${optionalString (mb.causes != []) ''
          imapsieve_mailbox${toString i}_causes = ${concatStringsSep " " mb.causes}
        ''}
      '')
      mailboxes);

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
      optionalString cfg.sieve.enable ''
        plugin {
          ${optionalString (cfg.sieve.plugins != [])
            "sieve_plugins = ${concatStringsSep " " (map (e: "sieve_${e}") cfg.sieve.plugins)}"}
          ${optionalString (cfg.sieve.extensions != [])
            "sieve_extensions = ${concatStringsSep " " cfg.sieve.extensions}"}
          ${optionalString (cfg.sieve.globalExtensions != [])
            "sieve_global_extensions = ${concatStringsSep " " cfg.sieve.globalExtensions}"}
        }
        protocol lmtp {
          mail_plugins = $mail_plugins sieve
        }
        protocol lda {
          mail_plugins = $mail_plugins sieve
        }
      ''
    )

    (
      optionalString cfg.sieve.imapsieve.enable ''
        protocol imap {
          mail_plugins = $mail_plugins imap_sieve
        }
        plugin {
          ${concatStringsSep "\n" (mapImapScripts cfg.sieve.imapsieve.mailboxes)}
        }
      ''
    )

    (
      optionalString (cfg.sieve.beforeScripts != []) ''
        plugin {
          ${concatStringsSep "\n" (mapScripts "before" cfg.sieve.beforeScripts)}
        }
      ''
    )

    (
      optionalString (cfg.sieve.defaultScript != null) ''
        plugin {
          sieve_default = ${compileSieveScripts}/sieve/default.sieve}
        }
      ''
    )

    (
      optionalString (cfg.sieve.afterScripts != []) ''
        plugin {
          ${concatStringsSep "\n" (mapScripts "after" cfg.sieve.afterScripts)}
        }
      ''
    )

    (
      optionalString (cfg.sieve.discardScript != null) ''
        plugin {
          sieve_discard = ${compileSieveScripts}/sieve/discard.sieve}
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
        description = lib.mdDoc "The name of the mailbox.";
      };
      auto = mkOption {
        type = types.enum [ "no" "create" "subscribe" ];
        default = "no";
        example = "subscribe";
        description = lib.mdDoc "Whether to automatically create or create and subscribe to the mailbox or not.";
      };
      specialUse = mkOption {
        type = types.nullOr (types.enum [ "All" "Archive" "Drafts" "Flagged" "Junk" "Sent" "Trash" ]);
        default = null;
        example = "Junk";
        description = lib.mdDoc "Null if no special use flag is set. Other than that every use flag mentioned in the RFC is valid.";
      };
      autoexpunge = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "60d";
        description = lib.mdDoc ''
          To automatically remove all email from the mailbox which is older than the
          specified time.
        '';
      };
    };
  };

  imapsieveMailboxes = {
    options = {
      name = mkOption {
        type = types.str;
        example = "Junk";
        description = lib.mdDoc ''
          Name of a mailbox for which administrator scripts are configured.
          This setting supports wildcards with a syntax compatible with the
          IMAP LIST command, meaning that this setting can apply to multiple or
          even all ("*") mailboxes.
        '';
      };
      beforeScript = mkOption {
        type = types.nullOr scriptType;
        default = null;
        description = lib.mdDoc ''
          Sieve script to run before any user script when an IMAP event of
          interest occurs.
        '';
      };
      afterScript = mkOption {
        type = types.nullOr scriptType;
        default = null;
        description = lib.mdDoc ''
          Sieve script to run after any user script when an IMAP event of
          interest occurs.
        '';
      };
      causes = mkOption {
        type = types.listOf (types.enum ["APPEND" "COPY" "FLAG"]);
        default = [];
        description = lib.mdDoc ''
          Only execute the administrator Sieve scripts for the mailbox
          when one of the listed IMAPSIEVE causes apply (currently either
          APPEND, COPY, or FLAG. This has no effect on the user script, which
          is always executed no matter the cause.
        '';
      };
      from = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "*";
        description = lib.mdDoc ''
          Only execute the administrator Sieve scripts for the mailbox
          configured with name option when the message originates from the
          indicated mailbox.
          This setting supports wildcards with a syntax compatible with the
          IMAP LIST command, meaning that this setting can apply to multiple or
          even all ("*") mailboxes.
        '';
      };
    };
  };
in
{
  options.services.dovecot2 = {
    enable = mkEnableOption (lib.mdDoc "the dovecot 2.x POP3/IMAP server");

    enablePop3 = mkEnableOption (lib.mdDoc "starting the POP3 listener (when Dovecot is enabled)");

    enableImap = mkEnableOption (lib.mdDoc "starting the IMAP listener (when Dovecot is enabled)") // { default = true; };

    enableLmtp = mkEnableOption (lib.mdDoc "starting the LMTP listener (when Dovecot is enabled)");

    protocols = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc "Additional listeners to start when Dovecot is enabled.";
    };

    user = mkOption {
      type = types.str;
      default = "dovecot2";
      description = lib.mdDoc "Dovecot user name.";
    };

    group = mkOption {
      type = types.str;
      default = "dovecot2";
      description = lib.mdDoc "Dovecot group name.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = "mail_debug = yes";
      description = lib.mdDoc "Additional entries to put verbatim into Dovecot's config file.";
    };

    mailPlugins =
      let
        plugins = hint: types.submodule {
          options = {
            enable = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc "mail plugins to enable as a list of strings to append to the ${hint} `$mail_plugins` configuration variable";
            };
          };
        };
      in
        mkOption {
          type = with types; submodule {
            options = {
              globally = mkOption {
                description = lib.mdDoc "Additional entries to add to the mail_plugins variable for all protocols";
                type = plugins "top-level";
                example = { enable = [ "virtual" ]; };
                default = { enable = []; };
              };
              perProtocol = mkOption {
                description = lib.mdDoc "Additional entries to add to the mail_plugins variable, per protocol";
                type = attrsOf (plugins "corresponding per-protocol");
                default = {};
                example = { imap = [ "imap_acl" ]; };
              };
            };
          };
          description = lib.mdDoc "Additional entries to add to the mail_plugins variable, globally and per protocol";
          example = {
            globally.enable = [ "acl" ];
            perProtocol.imap.enable = [ "imap_acl" ];
          };
          default = { globally.enable = []; perProtocol = {}; };
        };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc "Config file used for the whole dovecot configuration.";
      apply = v: if v != null then v else pkgs.writeText "dovecot.conf" dovecotConf;
    };

    mailLocation = mkOption {
      type = types.str;
      default = "maildir:/var/spool/mail/%u"; /* Same as inbox, as postfix */
      example = "maildir:~/mail:INBOX=/var/spool/mail/%u";
      description = lib.mdDoc ''
        Location that dovecot will use for mail folders. Dovecot mail_location option.
      '';
    };

    mailUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Default user to store mail for virtual users.";
    };

    mailGroup = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Default group to store mail for virtual users.";
    };

    createMailUser = mkEnableOption (lib.mdDoc ''automatically creating the user
      given in {option}`services.dovecot.user` and the group
      given in {option}`services.dovecot.group`.'') // { default = true; };

    modules = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.dovecot_pigeonhole ]";
      description = lib.mdDoc ''
        Symlinks the contents of lib/dovecot of every given package into
        /etc/dovecot/modules. This will make the given modules available
        if a dovecot package with the module_dir patch applied is being used.
      '';
    };

    sslCACert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Path to the server's CA certificate key.";
    };

    sslServerCert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Path to the server's public key.";
    };

    sslServerKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc "Path to the server's private key.";
    };

    enablePAM = mkEnableOption (lib.mdDoc "creating a own Dovecot PAM service and configure PAM user logins") // { default = true; };

    enableDHE = mkEnableOption (lib.mdDoc "ssl_dh and generation of primes for the key exchange") // { default = true; };

    sieve = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable and configure sieve support";
      };

      enableManageSieve = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Start the ManageSieve listener (when Sieve is enabled).";
      };

      plugins = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "imapsieve" "extprograms" ];
        description = lib.mdDoc "Sieve plugins to load";
      };

      extensions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["+editheader" "-duplicate"];
        description = lib.mdDoc ''
          Which Sieve language extensions are available to users. This can
          either be a complete list or can be modifications to the default list
          by prefixing with + or -.
        '';
      };

      globalExtensions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["+vnd.dovecot.pipe"];
        description = lib.mdDoc ''
          Which Sieve language extensions are ONLY avalable in global scripts.
          This can be used to restrict the use of certain Sieve extensions to
          administrator control, for instance when these extensions can cause
          security concerns. This setting has higher precedence than the
          extensions option, meaning that the extensions enabled with this
          setting are never available to the user's personal script no matter
          what is specified for the extensions option. The syntax of this
          setting is similar to the extensions option, with the difference that
          extensions are enabled or disabled for exclusive use in global
          scripts.
        '';
      };

      beforeScripts = mkOption {
        type = types.listOf scriptType;
        default = [];
        description = lib.mdDoc ''
          Sieve scripts to be executed before user script.
        '';
      };

      defaultScript = mkOption {
        type = types.nullOr scriptType;
        default = null;
        description = lib.mdDoc ''
          Default sieve script to be executed if user has no active script.
        '';
      };

      afterScripts = mkOption {
        type = types.listOf scriptType;
        default = [];
        description = lib.mdDoc ''
          Sieve scripts to be executed after user script.
        '';
      };

      discardScript = mkOption {
        type = types.nullOr scriptType;
        default = null;
        description = lib.mdDoc ''
          The location of a Sieve script that is run for any message that is
          about to be discarded; i.e., it is not delivered anywhere by the
          normal Sieve execution. This only happens when the "implicit keep" is
          canceled, by e.g. the "discard" action, and no actions that deliver
          the message are executed. This "discard script" can prevent
          discarding the message, by executing alternative actions. If the
          discard script does nothing, the message is still discarded as it
          would be when no discard script is configured.
        '';
      };

      imapsieve = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Whether to enable imapsieve plugin.";
        };
        mailboxes = mkOption {
          type = types.listOf (types.submodule imapsieveMailboxes);
          default = [];
          description = lib.mdDoc "Configure imapsieve mailbox rules.";
        };
      };
    };

    showPAMFailure = mkEnableOption (lib.mdDoc "showing the PAM failure message on authentication error (useful for OTPW)");

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
      description = lib.mdDoc "Configure mailboxes and auto create or subscribe them.";
    };

    enableQuota = mkEnableOption (lib.mdDoc "the dovecot quota service");

    quotaPort = mkOption {
      type = types.str;
      default = "12340";
      description = lib.mdDoc ''
        The Port the dovecot quota service binds to.
        If using postfix, add check_policy_service inet:localhost:12340 to your smtpd_recipient_restrictions in your postfix config.
      '';
    };
    quotaGlobalPerUser = mkOption {
      type = types.str;
      default = "100G";
      example = "10G";
      description = lib.mdDoc "Quota limit for the user in bytes. Supports suffixes b, k, M, G, T and %.";
    };

  };


  config = mkIf cfg.enable {
    security.pam.services.dovecot2 = mkIf cfg.enablePAM {};

    security.dhparams = mkIf (cfg.sslServerCert != null && cfg.enableDHE) {
      enable = true;
      params.dovecot2 = {};
    };
    services.dovecot2.modules = mkIf cfg.sieve.enable [pkgs.dovecot_pigeonhole];
    services.dovecot2.sieve.plugins = mkIf cfg.sieve.imapsieve.enable ["imapsieve"];
    services.dovecot2.protocols =
      optional cfg.enableImap "imap"
      ++ optional cfg.enablePop3 "pop3"
      ++ optional cfg.enableLmtp "lmtp"
      ++ optional (cfg.sieve.enable && cfg.sieve.enableManageSieve) "sieve";

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
    ];

  };
  imports = [
    (mkRemovedOptionModule [ "services" "dovecot2" "package" ] "")
    (mkMergedOptionModule
      [ [ "services" "dovecot2" "sieveScripts" "after" ]
        [ "services" "dovecot2" "sieveScripts" "after2" ]
        [ "services" "dovecot2" "sieveScripts" "after3" ]
        [ "services" "dovecot2" "sieveScripts" "after4" ]
        [ "services" "dovecot2" "sieveScripts" "after5" ]
        [ "services" "dovecot2" "sieveScripts" "after6" ]
        [ "services" "dovecot2" "sieveScripts" "after7" ]
        [ "services" "dovecot2" "sieveScripts" "after8" ]
        [ "services" "dovecot2" "sieveScripts" "after9" ]]
      [ "services" "dovecot2" "sieve" "afterScripts" ]
      (listOfScripts "after" 1))
    (mkMergedOptionModule
      [ [ "services" "dovecot2" "sieveScripts" "before" ]
        [ "services" "dovecot2" "sieveScripts" "before2" ]
        [ "services" "dovecot2" "sieveScripts" "before3" ]
        [ "services" "dovecot2" "sieveScripts" "before4" ]
        [ "services" "dovecot2" "sieveScripts" "before5" ]
        [ "services" "dovecot2" "sieveScripts" "before6" ]
        [ "services" "dovecot2" "sieveScripts" "before7" ]
        [ "services" "dovecot2" "sieveScripts" "before8" ]
        [ "services" "dovecot2" "sieveScripts" "before9" ]]
      [ "services" "dovecot2" "sieve" "beforeScripts" ]
      (listOfScripts "before" 1))
    (mkRenamedOptionModule [ "services" "dovecot2" "sieveScripts" "default" ] [ "services" "dovecot2" "sieve" "defaultScript" ])
    (mkRenamedOptionModule [ "services" "dovecot2" "sieveScripts" "discard" ] [ "services" "dovecot2" "sieve" "discardScript" ])
  ];
}
