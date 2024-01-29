{ options, config, lib, pkgs, ... }:

let
  inherit (lib) any attrValues concatMapStringsSep concatStrings
    concatStringsSep flatten imap1 isList literalExpression mapAttrsToList
    mkEnableOption mkIf mkOption mkRemovedOptionModule optional optionalAttrs
    optionalString singleton types mkRenamedOptionModule nameValuePair
    mapAttrs' listToAttrs filter;
  inherit (lib.strings) match;

  cfg = config.services.dovecot2;
  dovecotPkg = pkgs.dovecot;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  sieveScriptSettings = mapAttrs' (to: from: nameValuePair "sieve_${to}" "${stateDir}/sieve/${from}") cfg.sieve.scripts;
  imapSieveMailboxSettings = listToAttrs (flatten (imap1 (idx: el:
    singleton {
      name = "imapsieve_mailbox${toString idx}_name";
      value = el.name;
    } ++ optional (el.from != null) {
      name = "imapsieve_mailbox${toString idx}_from";
      value = el.from;
    } ++ optional (el.causes != []) {
      name = "imapsieve_mailbox${toString idx}_causes";
      value = concatStringsSep "," el.causes;
    } ++ optional (el.before != null) {
      name = "imapsieve_mailbox${toString idx}_before";
      value = "file:${stateDir}/imapsieve/before/${baseNameOf el.before}";
    } ++ optional (el.after != null) {
      name = "imapsieve_mailbox${toString idx}_after";
      value = "file:${stateDir}/imapsieve/after/${baseNameOf el.after}";
    }
  ) cfg.imapsieve.mailbox));

  mkExtraConfigCollisionWarning = term: ''
    You referred to ${term} in `services.dovecot2.extraConfig`.

    Due to gradual transition to structured configuration for plugin configuration, it is possible
    this will cause your plugin configuration to be ignored.

    Consider setting `services.dovecot2.pluginSettings.${term}` instead.
  '';

  # Those settings are automatically set based on other parts
  # of this module.
  automaticallySetPluginSettings = [
    "sieve_plugins"
    "sieve_extensions"
    "sieve_global_extensions"
    "sieve_pipe_bin_dir"
  ]
  ++ (builtins.attrNames sieveScriptSettings)
  ++ (builtins.attrNames imapSieveMailboxSettings);

  # The idea is to match everything that looks like `$term =`
  # but not `# $term something something`
  # or `# $term = some value` because those are comments.
  configContainsSetting = lines: term: (match "^[^#]*\b${term}\b.*=" lines) != null;

  warnAboutExtraConfigCollisions = map mkExtraConfigCollisionWarning (filter (configContainsSetting cfg.extraConfig) automaticallySetPluginSettings);

  sievePipeBinScriptDirectory = pkgs.linkFarm "sieve-pipe-bins" (map (el: {
      name = builtins.unsafeDiscardStringContext (baseNameOf el);
      path = el;
  }) cfg.sieve.pipeBins);

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

    # General plugin settings:
    # - sieve is mostly generated here, refer to `pluginSettings` to follow
    # the control flow.
    ''
      plugin {
        ${concatStringsSep "\n" (mapAttrsToList (key: value: "  ${key} = ${value}") cfg.pluginSettings)}
      }
    ''

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
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "dovecot2" "package" ] "")
    (mkRenamedOptionModule [ "services" "dovecot2" "sieveScripts" ] [ "services" "dovecot2" "sieve" "scripts" ])
  ];

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


    pluginSettings = mkOption {
      # types.str does not coerce from packages, like `sievePipeBinScriptDirectory`.
      type = types.attrsOf (types.oneOf [ types.str types.package ]);
      default = {};
      example = literalExpression ''
        {
          sieve = "file:~/sieve;active=~/.dovecot.sieve";
        }
      '';
      description = ''
        Plugin settings for dovecot in general, e.g. `sieve`, `sieve_default`, etc.

        Some of the other knobs of this module will influence by default the plugin settings, but you
        can still override any plugin settings.

        If you override a plugin setting, its value is cleared and you have to copy over the defaults.
      '';
    };

    imapsieve.mailbox = mkOption {
      default = [];
      description = "Configure Sieve filtering rules on IMAP actions";
      type = types.listOf (types.submodule ({ config, ... }: {
        options = {
          name = mkOption {
            description = ''
              This setting configures the name of a mailbox for which administrator scripts are configured.

              The settings defined hereafter with matching sequence numbers apply to the mailbox named by this setting.

              This setting supports wildcards with a syntax compatible with the IMAP LIST command, meaning that this setting can apply to multiple or even all ("*") mailboxes.
            '';
            example = "Junk";
            type = types.str;
          };

          from = mkOption {
            default = null;
            description = ''
              Only execute the administrator Sieve scripts for the mailbox configured with services.dovecot2.imapsieve.mailbox.<name>.name when the message originates from the indicated mailbox.

              This setting supports wildcards with a syntax compatible with the IMAP LIST command, meaning that this setting can apply to multiple or even all ("*") mailboxes.
            '';
            example = "*";
            type = types.nullOr types.str;
          };

          causes = mkOption {
            default = [ ];
            description = ''
              Only execute the administrator Sieve scripts for the mailbox configured with services.dovecot2.imapsieve.mailbox.<name>.name when one of the listed IMAPSIEVE causes apply.

              This has no effect on the user script, which is always executed no matter the cause.
            '';
            example = [ "COPY" "APPEND" ];
            type = types.listOf (types.enum [ "APPEND" "COPY" "FLAG" ]);
          };

          before = mkOption {
            default = null;
            description = ''
              When an IMAP event of interest occurs, this sieve script is executed before any user script respectively.

              This setting each specify the location of a single sieve script. The semantics of this setting is similar to sieve_before: the specified scripts form a sequence together with the user script in which the next script is only executed when an (implicit) keep action is executed.
            '';
            example = literalExpression "./report-spam.sieve";
            type = types.nullOr types.path;
          };

          after = mkOption {
            default = null;
            description = ''
              When an IMAP event of interest occurs, this sieve script is executed after any user script respectively.

              This setting each specify the location of a single sieve script. The semantics of this setting is similar to sieve_after: the specified scripts form a sequence together with the user script in which the next script is only executed when an (implicit) keep action is executed.
            '';
            example = literalExpression "./report-spam.sieve";
            type = types.nullOr types.path;
          };
        };
      }));
    };

    sieve = {
      plugins = mkOption {
        default = [];
        example = [ "sieve_extprograms" ];
        description = "Sieve plugins to load";
        type = types.listOf types.str;
      };

      extensions = mkOption {
        default = [];
        description = "Sieve extensions for use in user scripts";
        example = [ "notify" "imapflags" "vnd.dovecot.filter" ];
        type = types.listOf types.str;
      };

      globalExtensions = mkOption {
        default = [];
        example = [ "vnd.dovecot.environment" ];
        description = "Sieve extensions for use in global scripts";
        type = types.listOf types.str;
      };

      scripts = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = lib.mdDoc "Sieve scripts to be executed. Key is a sequence, e.g. 'before2', 'after' etc.";
      };

      pipeBins = mkOption {
        default = [];
        example = literalExpression ''
          map lib.getExe [
            (pkgs.writeShellScriptBin "learn-ham.sh" "exec ''${pkgs.rspamd}/bin/rspamc learn_ham")
            (pkgs.writeShellScriptBin "learn-spam.sh" "exec ''${pkgs.rspamd}/bin/rspamc learn_spam")
          ]
        '';
        description = "Programs available for use by the vnd.dovecot.pipe extension";
        type = types.listOf types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    security.pam.services.dovecot2 = mkIf cfg.enablePAM {};

    security.dhparams = mkIf (cfg.sslServerCert != null && cfg.enableDHE) {
      enable = true;
      params.dovecot2 = {};
    };

    services.dovecot2 = {
      protocols =
        optional cfg.enableImap "imap"
        ++ optional cfg.enablePop3 "pop3"
        ++ optional cfg.enableLmtp "lmtp";

      mailPlugins = mkIf cfg.enableQuota {
        globally.enable = [ "quota" ];
        perProtocol.imap.enable = [ "imap_quota" ];
      };

      sieve.plugins =
        optional (cfg.imapsieve.mailbox != []) "sieve_imapsieve"
        ++ optional (cfg.sieve.pipeBins != []) "sieve_extprograms";

      sieve.globalExtensions = optional (cfg.sieve.pipeBins != []) "vnd.dovecot.pipe";

      pluginSettings = lib.mapAttrs (n: lib.mkDefault) ({
        sieve_plugins = concatStringsSep " " cfg.sieve.plugins;
        sieve_extensions = concatStringsSep " " (map (el: "+${el}") cfg.sieve.extensions);
        sieve_global_extensions = concatStringsSep " " (map (el: "+${el}") cfg.sieve.globalExtensions);
        sieve_pipe_bin_dir = sievePipeBinScriptDirectory;
      } // sieveScriptSettings // imapSieveMailboxSettings);
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
        rm -rf ${stateDir}/sieve ${stateDir}/imapsieve
      '' + optionalString (cfg.sieve.scripts != {}) ''
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
        ) cfg.sieve.scripts
      )}
        chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/sieve'
      ''
      + optionalString (cfg.imapsieve.mailbox != []) ''
        mkdir -p ${stateDir}/imapsieve/{before,after}

        ${
          concatMapStringsSep "\n"
            (el:
              optionalString (el.before != null) ''
                cp -p ${el.before} ${stateDir}/imapsieve/before/${baseNameOf el.before}
                ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/before/${baseNameOf el.before}'
              ''
              + optionalString (el.after != null) ''
                cp -p ${el.after} ${stateDir}/imapsieve/after/${baseNameOf el.after}
                ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/after/${baseNameOf el.after}'
              ''
            )
            cfg.imapsieve.mailbox
        }

        ${
          optionalString (cfg.mailUser != null && cfg.mailGroup != null)
            "chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/imapsieve'"
        }
      '';
    };

    environment.systemPackages = [ dovecotPkg ];

    warnings = warnAboutExtraConfigCollisions;

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
        assertion = cfg.sieve.scripts != {} -> (cfg.mailUser != null && cfg.mailGroup != null);
        message = "dovecot requires mailUser and mailGroup to be set when `sieve.scripts` is set";
      }
    ];

  };

  meta.maintainers = [ lib.maintainers.dblsaiko ];
}
