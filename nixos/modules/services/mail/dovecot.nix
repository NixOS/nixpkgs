{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrValues
    concatMapStringsSep
    concatStrings
    concatStringsSep
    flatten
    imap1
    literalExpression
    mapAttrsToList
    mkEnableOption
    mkIf
    lib.mkOption
    mkRemovedOptionModule
    lib.optional
    lib.optionalAttrs
    lib.optionalString
    singleton
    types
    mkRenamedOptionModule
    nameValuePair
    mapAttrs'
    listToAttrs
    filter
    ;
  inherit (lib.strings) match;

  cfg = config.services.dovecot2;
  dovecotPkg = pkgs.dovecot;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  sieveScriptSettings = mapAttrs' (
    to: _: nameValuePair "sieve_${to}" "${stateDir}/sieve/${to}"
  ) cfg.sieve.scripts;
  imapSieveMailboxSettings = listToAttrs (
    flatten (
      imap1 (
        idx: el:
        singleton {
          name = "imapsieve_mailbox${toString idx}_name";
          value = el.name;
        }
        ++ lib.optional (el.from != null) {
          name = "imapsieve_mailbox${toString idx}_from";
          value = el.from;
        }
        ++ lib.optional (el.causes != [ ]) {
          name = "imapsieve_mailbox${toString idx}_causes";
          value = concatStringsSep "," el.causes;
        }
        ++ lib.optional (el.before != null) {
          name = "imapsieve_mailbox${toString idx}_before";
          value = "file:${stateDir}/imapsieve/before/${baseNameOf el.before}";
        }
        ++ lib.optional (el.after != null) {
          name = "imapsieve_mailbox${toString idx}_after";
          value = "file:${stateDir}/imapsieve/after/${baseNameOf el.after}";
        }
      ) cfg.imapsieve.mailbox
    )
  );

  mkExtraConfigCollisionWarning = term: ''
    You referred to ${term} in `services.dovecot2.extraConfig`.

    Due to gradual transition to structured configuration for plugin configuration, it is possible
    this will cause your plugin configuration to be ignored.

    Consider setting `services.dovecot2.pluginSettings.${term}` instead.
  '';

  # Those settings are automatically set based on other parts
  # of this module.
  automaticallySetPluginSettings =
    [
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

  warnAboutExtraConfigCollisions = map mkExtraConfigCollisionWarning (
    filter (configContainsSetting cfg.extraConfig) automaticallySetPluginSettings
  );

  sievePipeBinScriptDirectory = pkgs.linkFarm "sieve-pipe-bins" (
    map (el: {
      name = builtins.unsafeDiscardStringContext (baseNameOf el);
      path = el;
    }) cfg.sieve.pipeBins
  );

  dovecotConf = concatStrings [
    ''
      base_dir = ${baseDir}
      protocols = ${lib.concatStringsSep " " cfg.protocols}
      sendmail_path = /run/wrappers/bin/sendmail
      # defining mail_plugins must be done before the first protocol {} filter because of https://doc.dovecot.org/configuration_manual/config_file/config_file_syntax/#variable-expansion
      mail_plugins = $mail_plugins ${lib.concatStringsSep " " cfg.mailPlugins.globally.enable}
    ''

    (lib.concatStringsSep "\n" (
      mapAttrsToList (protocol: plugins: ''
        protocol ${protocol} {
          mail_plugins = $mail_plugins ${lib.concatStringsSep " " plugins.enable}
        }
      '') cfg.mailPlugins.perProtocol
    ))

    (
      if cfg.sslServerCert == null then
        ''
          ssl = no
          disable_plaintext_auth = no
        ''
      else
        ''
          ssl_cert = <${cfg.sslServerCert}
          ssl_key = <${cfg.sslServerKey}
          ${lib.optionalString (cfg.sslCACert != null) ("ssl_ca = <" + cfg.sslCACert)}
          ${lib.optionalString cfg.enableDHE ''ssl_dh = <${config.security.dhparams.params.dovecot2.path}''}
          disable_plaintext_auth = yes
        ''
    )

    ''
      default_internal_user = ${cfg.user}
      default_internal_group = ${cfg.group}
      ${lib.optionalString (cfg.mailUser != null) "mail_uid = ${cfg.mailUser}"}
      ${lib.optionalString (cfg.mailGroup != null) "mail_gid = ${cfg.mailGroup}"}

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
        args = ${lib.optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2
      }
    '')

    (optionalString (cfg.mailboxes != { }) ''
      namespace inbox {
        inbox=yes
        ${lib.concatStringsSep "\n" (map mailboxConfig (lib.attrValues cfg.mailboxes))}
      }
    '')

    (optionalString cfg.enableQuota ''
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
    '')

    # General plugin settings:
    # - sieve is mostly generated here, refer to `pluginSettings` to follow
    # the control flow.
    ''
      plugin {
        ${lib.concatStringsSep "\n" (mapAttrsToList (key: value: "  ${key} = ${value}") cfg.pluginSettings)}
      }
    ''

    cfg.extraConfig
  ];

  modulesDir = pkgs.symlinkJoin {
    name = "dovecot-modules";
    paths = map (pkg: "${pkg}/lib/dovecot") (
      [ dovecotPkg ] ++ map (module: module.override { dovecot = dovecotPkg; }) cfg.modules
    );
  };

  mailboxConfig =
    mailbox:
    ''
      mailbox "${mailbox.name}" {
        auto = ${toString mailbox.auto}
    ''
    + lib.optionalString (mailbox.autoexpunge != null) ''
      autoexpunge = ${mailbox.autoexpunge}
    ''
    + lib.optionalString (mailbox.specialUse != null) ''
      special_use = \${toString mailbox.specialUse}
    ''
    + "}";

  mailboxes =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.strMatching ''[^"]+'';
          example = "Spam";
          default = name;
          readOnly = true;
          description = "The name of the mailbox.";
        };
        auto = lib.mkOption {
          type = lib.types.enum [
            "no"
            "create"
            "subscribe"
          ];
          default = "no";
          example = "subscribe";
          description = "Whether to automatically create or create and subscribe to the mailbox or not.";
        };
        specialUse = lib.mkOption {
          type = lib.types.nullOr (
            types.enum [
              "All"
              "Archive"
              "Drafts"
              "Flagged"
              "Junk"
              "Sent"
              "Trash"
            ]
          );
          default = null;
          example = "Junk";
          description = "Null if no special use flag is set. Other than that every use flag mentioned in the RFC is valid.";
        };
        autoexpunge = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
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
    (lib.mkRemovedOptionModule [ "services" "dovecot2" "package" ] "")
    (lib.mkRenamedOptionModule
      [ "services" "dovecot2" "sieveScripts" ]
      [ "services" "dovecot2" "sieve" "scripts" ]
    )
  ];

  options.services.dovecot2 = {
    enable = lib.mkEnableOption "the dovecot 2.x POP3/IMAP server";

    enablePop3 = mkEnableOption "starting the POP3 listener (when Dovecot is enabled)";

    enableImap = mkEnableOption "starting the IMAP listener (when Dovecot is enabled)" // {
      default = true;
    };

    enableLmtp = mkEnableOption "starting the LMTP listener (when Dovecot is enabled)";

    protocols = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional listeners to start when Dovecot is enabled.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "dovecot2";
      description = "Dovecot user name.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "dovecot2";
      description = "Dovecot group name.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "mail_debug = yes";
      description = "Additional entries to put verbatim into Dovecot's config file.";
    };

    mailPlugins =
      let
        plugins =
          hint:
          types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "mail plugins to enable as a list of strings to append to the ${hint} `$mail_plugins` configuration variable";
              };
            };
          };
      in
      lib.mkOption {
        type =
          with lib.types;
          submodule {
            options = {
              globally = lib.mkOption {
                description = "Additional entries to add to the mail_plugins variable for all protocols";
                type = plugins "top-level";
                example = {
                  enable = [ "virtual" ];
                };
                default = {
                  enable = [ ];
                };
              };
              perProtocol = lib.mkOption {
                description = "Additional entries to add to the mail_plugins variable, per protocol";
                type = attrsOf (plugins "corresponding per-protocol");
                default = { };
                example = {
                  imap = [ "imap_acl" ];
                };
              };
            };
          };
        description = "Additional entries to add to the mail_plugins variable, globally and per protocol";
        example = {
          globally.enable = [ "acl" ];
          perProtocol.imap.enable = [ "imap_acl" ];
        };
        default = {
          globally.enable = [ ];
          perProtocol = { };
        };
      };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Config file used for the whole dovecot configuration.";
      apply = v: if v != null then v else pkgs.writeText "dovecot.conf" dovecotConf;
    };

    mailLocation = lib.mkOption {
      type = lib.types.str;
      default = "maildir:/var/spool/mail/%u"; # Same as inbox, as postfix
      example = "maildir:~/mail:INBOX=/var/spool/mail/%u";
      description = ''
        Location that dovecot will use for mail folders. Dovecot mail_location option.
      '';
    };

    mailUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default user to store mail for virtual users.";
    };

    mailGroup = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default group to store mail for virtual users.";
    };

    createMailUser =
      mkEnableOption ''
        automatically creating the user
              given in {option}`services.dovecot.user` and the group
              given in {option}`services.dovecot.group`''
      // {
        default = true;
      };

    modules = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.dovecot_pigeonhole ]";
      description = ''
        Symlinks the contents of lib/dovecot of every given package into
        /etc/dovecot/modules. This will make the given modules available
        if a dovecot package with the module_dir patch applied is being used.
      '';
    };

    sslCACert = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the server's CA certificate key.";
    };

    sslServerCert = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the server's public key.";
    };

    sslServerKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the server's private key.";
    };

    enablePAM = mkEnableOption "creating a own Dovecot PAM service and configure PAM user logins" // {
      default = true;
    };

    enableDHE = mkEnableOption "ssl_dh and generation of primes for the key exchange" // {
      default = true;
    };

    showPAMFailure = mkEnableOption "showing the PAM failure message on authentication error (useful for OTPW)";

    mailboxes = lib.mkOption {
      type =
        with lib.types;
        coercedTo (listOf unspecified) (
          list:
          listToAttrs (
            map (entry: {
              name = entry.name;
              value = removeAttrs entry [ "name" ];
            }) list
          )
        ) (attrsOf (submodule mailboxes));
      default = { };
      example = lib.literalExpression ''
        {
          Spam = { specialUse = "Junk"; auto = "create"; };
        }
      '';
      description = "Configure mailboxes and auto create or subscribe them.";
    };

    enableQuota = mkEnableOption "the dovecot quota service";

    quotaPort = lib.mkOption {
      type = lib.types.str;
      default = "12340";
      description = ''
        The Port the dovecot quota service binds to.
        If using postfix, add check_policy_service inet:localhost:12340 to your smtpd_recipient_restrictions in your postfix config.
      '';
    };
    quotaGlobalPerUser = lib.mkOption {
      type = lib.types.str;
      default = "100G";
      example = "10G";
      description = "Quota limit for the user in bytes. Supports suffixes b, k, M, G, T and %.";
    };

    pluginSettings = lib.mkOption {
      # types.str does not coerce from packages, like `sievePipeBinScriptDirectory`.
      type = lib.types.attrsOf (
        types.oneOf [
          types.str
          types.package
        ]
      );
      default = { };
      example = lib.literalExpression ''
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

    imapsieve.mailbox = lib.mkOption {
      default = [ ];
      description = "Configure Sieve filtering rules on IMAP actions";
      type = lib.types.listOf (
        types.submodule (
          { config, ... }:
          {
            options = {
              name = lib.mkOption {
                description = ''
                  This setting configures the name of a mailbox for which administrator scripts are configured.

                  The settings defined hereafter with matching sequence numbers apply to the mailbox named by this setting.

                  This setting supports wildcards with a syntax compatible with the IMAP LIST command, meaning that this setting can apply to multiple or even all ("*") mailboxes.
                '';
                example = "Junk";
                type = lib.types.str;
              };

              from = lib.mkOption {
                default = null;
                description = ''
                  Only execute the administrator Sieve scripts for the mailbox configured with services.dovecot2.imapsieve.mailbox.<name>.name when the message originates from the indicated mailbox.

                  This setting supports wildcards with a syntax compatible with the IMAP LIST command, meaning that this setting can apply to multiple or even all ("*") mailboxes.
                '';
                example = "*";
                type = lib.types.nullOr lib.types.str;
              };

              causes = lib.mkOption {
                default = [ ];
                description = ''
                  Only execute the administrator Sieve scripts for the mailbox configured with services.dovecot2.imapsieve.mailbox.<name>.name when one of the listed IMAPSIEVE causes apply.

                  This has no effect on the user script, which is always executed no matter the cause.
                '';
                example = [
                  "COPY"
                  "APPEND"
                ];
                type = lib.types.listOf (
                  types.enum [
                    "APPEND"
                    "COPY"
                    "FLAG"
                  ]
                );
              };

              before = lib.mkOption {
                default = null;
                description = ''
                  When an IMAP event of interest occurs, this sieve script is executed before any user script respectively.

                  This setting each specify the location of a single sieve script. The semantics of this setting is similar to sieve_before: the specified scripts form a sequence together with the user script in which the next script is only executed when an (implicit) keep action is executed.
                '';
                example = lib.literalExpression "./report-spam.sieve";
                type = lib.types.nullOr lib.types.path;
              };

              after = lib.mkOption {
                default = null;
                description = ''
                  When an IMAP event of interest occurs, this sieve script is executed after any user script respectively.

                  This setting each specify the location of a single sieve script. The semantics of this setting is similar to sieve_after: the specified scripts form a sequence together with the user script in which the next script is only executed when an (implicit) keep action is executed.
                '';
                example = lib.literalExpression "./report-spam.sieve";
                type = lib.types.nullOr lib.types.path;
              };
            };
          }
        )
      );
    };

    sieve = {
      plugins = lib.mkOption {
        default = [ ];
        example = [ "sieve_extprograms" ];
        description = "Sieve plugins to load";
        type = lib.types.listOf lib.types.str;
      };

      extensions = lib.mkOption {
        default = [ ];
        description = "Sieve extensions for use in user scripts";
        example = [
          "notify"
          "imapflags"
          "vnd.dovecot.filter"
        ];
        type = lib.types.listOf lib.types.str;
      };

      globalExtensions = lib.mkOption {
        default = [ ];
        example = [ "vnd.dovecot.environment" ];
        description = "Sieve extensions for use in global scripts";
        type = lib.types.listOf lib.types.str;
      };

      scripts = lib.mkOption {
        type = lib.types.attrsOf types.path;
        default = { };
        description = "Sieve scripts to be executed. Key is a sequence, e.g. 'before2', 'after' etc.";
      };

      pipeBins = lib.mkOption {
        default = [ ];
        example = lib.literalExpression ''
          map lib.getExe [
            (pkgs.writeShellScriptBin "learn-ham.sh" "exec ''${pkgs.rspamd}/bin/rspamc learn_ham")
            (pkgs.writeShellScriptBin "learn-spam.sh" "exec ''${pkgs.rspamd}/bin/rspamc learn_spam")
          ]
        '';
        description = "Programs available for use by the vnd.dovecot.pipe extension";
        type = lib.types.listOf lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.dovecot2 = lib.mkIf cfg.enablePAM { };

    security.dhparams = lib.mkIf (cfg.sslServerCert != null && cfg.enableDHE) {
      enable = true;
      params.dovecot2 = { };
    };

    services.dovecot2 = {
      protocols =
        lib.optional cfg.enableImap "imap" ++ lib.optional cfg.enablePop3 "pop3" ++ lib.optional cfg.enableLmtp "lmtp";

      mailPlugins = lib.mkIf cfg.enableQuota {
        globally.enable = [ "quota" ];
        perProtocol.imap.enable = [ "imap_quota" ];
      };

      sieve.plugins =
        lib.optional (cfg.imapsieve.mailbox != [ ]) "sieve_imapsieve"
        ++ lib.optional (cfg.sieve.pipeBins != [ ]) "sieve_extprograms";

      sieve.globalExtensions = lib.optional (cfg.sieve.pipeBins != [ ]) "vnd.dovecot.pipe";

      pluginSettings = lib.mapAttrs (n: lib.mkDefault) (
        {
          sieve_plugins = concatStringsSep " " cfg.sieve.plugins;
          sieve_extensions = concatStringsSep " " (map (el: "+${el}") cfg.sieve.extensions);
          sieve_global_extensions = concatStringsSep " " (map (el: "+${el}") cfg.sieve.globalExtensions);
          sieve_pipe_bin_dir = sievePipeBinScriptDirectory;
        }
        // sieveScriptSettings
        // imapSieveMailboxSettings
      );
    };

    users.users =
      {
        dovenull = {
          uid = config.ids.uids.dovenull2;
          description = "Dovecot user for untrusted logins";
          group = "dovenull";
        };
      }
      // lib.optionalAttrs (cfg.user == "dovecot2") {
        dovecot2 = {
          uid = config.ids.uids.dovecot2;
          description = "Dovecot user";
          group = cfg.group;
        };
      }
      // lib.optionalAttrs (cfg.createMailUser && cfg.mailUser != null) {
        ${cfg.mailUser} = {
          description = "Virtual Mail User";
          isSystemUser = true;
        } // lib.optionalAttrs (cfg.mailGroup != null) { group = cfg.mailGroup; };
      };

    users.groups =
      {
        dovenull.gid = config.ids.gids.dovenull2;
      }
      // lib.optionalAttrs (cfg.group == "dovecot2") {
        dovecot2.gid = config.ids.gids.dovecot2;
      }
      // lib.optionalAttrs (cfg.createMailUser && cfg.mailGroup != null) {
        ${cfg.mailGroup} = { };
      };

    environment.etc."dovecot/modules".source = modulesDir;
    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot2 = {
      description = "Dovecot IMAP/POP3 server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.configFile
        modulesDir
      ];

      startLimitIntervalSec = 60; # 1 min
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
      preStart =
        ''
          rm -rf ${stateDir}/sieve ${stateDir}/imapsieve
        ''
        + lib.optionalString (cfg.sieve.scripts != { }) ''
          mkdir -p ${stateDir}/sieve
          ${lib.concatStringsSep "\n" (
            mapAttrsToList (to: from: ''
              if [ -d '${from}' ]; then
                mkdir '${stateDir}/sieve/${to}'
                cp -p "${from}/"*.sieve '${stateDir}/sieve/${to}'
              else
                cp -p '${from}' '${stateDir}/sieve/${to}'
              fi
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/sieve/${to}'
            '') cfg.sieve.scripts
          )}
          chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/sieve'
        ''
        + lib.optionalString (cfg.imapsieve.mailbox != [ ]) ''
          mkdir -p ${stateDir}/imapsieve/{before,after}

          ${concatMapStringsSep "\n" (
            el:
            lib.optionalString (el.before != null) ''
              cp -p ${el.before} ${stateDir}/imapsieve/before/${baseNameOf el.before}
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/before/${baseNameOf el.before}'
            ''
            + lib.optionalString (el.after != null) ''
              cp -p ${el.after} ${stateDir}/imapsieve/after/${baseNameOf el.after}
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/after/${baseNameOf el.after}'
            ''
          ) cfg.imapsieve.mailbox}

          ${lib.optionalString (
            cfg.mailUser != null && cfg.mailGroup != null
          ) "chown -R '${cfg.mailUser}:${cfg.mailGroup}' '${stateDir}/imapsieve'"}
        '';
    };

    environment.systemPackages = [ dovecotPkg ];

    warnings = warnAboutExtraConfigCollisions;

    assertions = [
      {
        assertion =
          (cfg.sslServerCert == null) == (cfg.sslServerKey == null)
          && (cfg.sslCACert != null -> !(cfg.sslServerCert == null || cfg.sslServerKey == null));
        message = "dovecot needs both sslServerCert and sslServerKey defined for working crypto";
      }
      {
        assertion = cfg.showPAMFailure -> cfg.enablePAM;
        message = "dovecot is configured with showPAMFailure while enablePAM is disabled";
      }
      {
        assertion = cfg.sieve.scripts != { } -> (cfg.mailUser != null && cfg.mailGroup != null);
        message = "dovecot requires mailUser and mailGroup to be set when `sieve.scripts` is set";
      }
    ];

  };

  meta.maintainers = [ lib.maintainers.dblsaiko ];
}
