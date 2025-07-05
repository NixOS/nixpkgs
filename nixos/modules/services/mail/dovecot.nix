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
    isBool
    isDerivation
    isInt
    isList
    isPath
    isString
    literalExpression
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkChangedOptionModule
    mkRemovedOptionModule
    optional
    optionalAttrs
    optionalString
    singleton
    types
    mkRenamedOptionModule
    nameValuePair
    mapAttrs'
    listToAttrs
    filter
    filterAttrs
    ;
  inherit (lib.generators) toPretty;
  inherit (lib.lists)
    findFirstIndex
    length
    sublist
    reverseList
    ;
  inherit (lib.strings) escape match splitString;

  cfg = config.services.dovecot2;
  dovecotPkg = pkgs.dovecot;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  /*
    Helper: Format string in way that may strech over multiple
    lines in a Dovecot configuration file

    This is a little complicated since Dovecot does not like when the last
    line is empty, so we first have to truncate all trailing empty lines
    before when can join them using the continuation line syntax.
  */
  formatDovecotMultiline =
    string:
    let
      # Split input into line list
      lines = splitString "\n" string;
      # Find index of last non-empty line in line list
      lastContentIndex =
        length lines
        - (findFirstIndex (
          line: match "[[:space:]]*" line == null # <=> Line is not empty
        ) (length lines - 1) (reverseList lines));
      # Drop empty trailing lines from line list
      trimmedLines = sublist 0 lastContentIndex lines;
    in
    # Reassemble content without trailing lines but with continuation markers
    concatStringsSep " \\\n" trimmedLines;

  /*
    Helper: Apply string escaping and quotation to Dovecot string if needed

    Dovecot is sometimes touchy about strings being quoted, so this only
    quotes the string when it is actually needed.
  */
  escapeDovecotString =
    string:
    let
      escapedString = escape [ "\\" "\"" ] string;
    in
    if match ''[[:space:]]*<.*|.*[[:space:]#"\\].*|^$'' string != null then
      "\"${formatDovecotMultiline escapedString}\""
    else
      string;

  /*
    Helper: Convert a Dovecot value to a string

    Strings are escaped except for config variable interpolation, as such
    this function is unsuitable for performing in-Dovecot variable
    substitutions, however these can also easily be done using Nix instead.

    Reference: https://doc.dovecot.org/settings/types/
  */
  mkDovecotValue =
    value:
    (
      if isString value || isPath value || isDerivation value then
        escapeDovecotString (toString value)
      else if isInt value then
        toString value
      else if isBool value then
        if value then "yes" else "no"
      else if isList value then
        concatMapStringsSep " " mkDovecotValue value
      else
        throw "mkDovecotValue: value not supported: ${toPretty { } value}"
    );

  /*
    Helper: Convert a complete Dovecot settings key list to a multiline string

    Reference: https://doc.dovecot.org/configuration_manual/config_file/
  */
  toDovecotKeyValue =
    indent: settings:
    concatStringsSep "\n" (
      mapAttrsToList (name: value: "${indent}${name} = ${mkDovecotValue value}") (
        filterAttrs (n: v: v != null) settings
      )
    );

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
        ++ optional (el.from != null) {
          name = "imapsieve_mailbox${toString idx}_from";
          value = el.from;
        }
        ++ optional (el.causes != [ ]) {
          name = "imapsieve_mailbox${toString idx}_causes";
          value = concatStringsSep "," el.causes;
        }
        ++ optional (el.before != null) {
          name = "imapsieve_mailbox${toString idx}_before";
          value = "file:${stateDir}/imapsieve/before/${baseNameOf el.before}";
        }
        ++ optional (el.after != null) {
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
  configContainsSetting = lines: term: (match "[[:blank:]]*${term}[[:blank:]]*=.*" lines) != null;

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
      protocols = ${concatStringsSep " " cfg.protocols}
      sendmail_path = /run/wrappers/bin/sendmail
      mail_plugin_dir = /run/current-system/sw/lib/dovecot/modules
      # defining mail_plugins must be done before the first protocol {} filter because of https://doc.dovecot.org/configuration_manual/config_file/config_file_syntax/#variable-expansion
      mail_plugins = $mail_plugins ${concatStringsSep " " cfg.mailPlugins.globally.enable}
    ''

    (concatStringsSep "\n" (
      mapAttrsToList (protocol: plugins: ''
        protocol ${protocol} {
          mail_plugins = $mail_plugins ${concatStringsSep " " plugins.enable}
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

    (optionalString cfg.enablePAM ''
      userdb {
        driver = passwd
      }

      passdb {
        driver = pam
        args = ${optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2
      }
    '')

    (optionalString (cfg.mailboxes != { }) ''
      namespace inbox {
        inbox=yes
        ${concatStringsSep "\n" (map mailboxConfig (attrValues cfg.mailboxes))}
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
      ${toDovecotKeyValue "  " cfg.pluginSettings}
      }
    ''

    cfg.extraConfig
  ];

  mailboxConfig =
    mailbox:
    ''
      mailbox "${mailbox.name}" {
        auto = ${toString mailbox.auto}
    ''
    + optionalString (mailbox.autoexpunge != null) ''
      autoexpunge = ${mailbox.autoexpunge}
    ''
    + optionalString (mailbox.specialUse != null) ''
      special_use = \${toString mailbox.specialUse}
    ''
    + "}";

  mailboxes =
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.strMatching ''[^"]+'';
          example = "Spam";
          default = name;
          readOnly = true;
          description = "The name of the mailbox.";
        };
        auto = mkOption {
          type = types.enum [
            "no"
            "create"
            "subscribe"
          ];
          default = "no";
          example = "subscribe";
          description = "Whether to automatically create or create and subscribe to the mailbox or not.";
        };
        specialUse = mkOption {
          type = types.nullOr (
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
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "modules"
    ] "Now need to use `environment.systemPackages` to load additional Dovecot modules")
    (mkRenamedOptionModule
      [ "services" "dovecot2" "sieveScripts" ]
      [ "services" "dovecot2" "sieve" "scripts" ]
    )
    (mkRenamedOptionModule
      [ "services" "dovecot2" "sieve" "plugins" ]
      [ "services" "dovecot2" "pluginSettings" "sieve_plugins" ]
    )
    (mkChangedOptionModule
      [ "services" "dovecot2" "sieve" "extensions" ]
      [ "services" "dovecot2" "pluginSettings" "sieve_extensions" ]
      (config: map (el: "+${el}") config.services.dovecot2.sieve.extensions)
    )
    (mkChangedOptionModule
      [ "services" "dovecot2" "sieve" "globalExtensions" ]
      [ "services" "dovecot2" "pluginSettings" "sieve_global_extensions" ]
      (config: map (el: "+${el}") config.services.dovecot2.sieve.globalExtensions)
    )
  ];

  options.services.dovecot2 = {
    enable = mkEnableOption "the dovecot 2.x POP3/IMAP server";

    enablePop3 = mkEnableOption "starting the POP3 listener (when Dovecot is enabled)";

    enableImap = mkEnableOption "starting the IMAP listener (when Dovecot is enabled)" // {
      default = true;
    };

    enableLmtp = mkEnableOption "starting the LMTP listener (when Dovecot is enabled)";

    protocols = mkOption {
      type = types.listOf types.str;
      default = [ ];
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
        plugins =
          hint:
          types.submodule {
            options = {
              enable = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "mail plugins to enable as a list of strings to append to the ${hint} `$mail_plugins` configuration variable";
              };
            };
          };
      in
      mkOption {
        type =
          with types;
          submodule {
            options = {
              globally = mkOption {
                description = "Additional entries to add to the mail_plugins variable for all protocols";
                type = plugins "top-level";
                example = {
                  enable = [ "virtual" ];
                };
                default = {
                  enable = [ ];
                };
              };
              perProtocol = mkOption {
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

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Config file used for the whole dovecot configuration.";
      apply = v: if v != null then v else pkgs.writeText "dovecot.conf" dovecotConf;
    };

    mailLocation = mkOption {
      type = types.str;
      default = "maildir:/var/spool/mail/%u"; # Same as inbox, as postfix
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

    createMailUser =
      mkEnableOption ''
        automatically creating the user
              given in {option}`services.dovecot.user` and the group
              given in {option}`services.dovecot.group`.''
      // {
        default = true;
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

    enablePAM = mkEnableOption "creating a own Dovecot PAM service and configure PAM user logins" // {
      default = true;
    };

    enableDHE = mkEnableOption "ssl_dh and generation of primes for the key exchange" // {
      default = true;
    };

    showPAMFailure = mkEnableOption "showing the PAM failure message on authentication error (useful for OTPW)";

    mailboxes = mkOption {
      type =
        with types;
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
      example = literalExpression ''
        {
          Spam = { specialUse = "Junk"; auto = "create"; };
        }
      '';
      description = "Configure mailboxes and auto create or subscribe them.";
    };

    enableQuota = mkEnableOption "the dovecot quota service";

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

    pluginSettings = mkOption {
      # types.str does not coerce from packages, like `sievePipeBinScriptDirectory`.
      type = types.submodule {
        freeformType =
          let
            singleValueType = types.oneOf [
              types.bool
              types.int
              types.str
              types.package
            ];
          in
          types.attrsOf (types.nullOr (types.either singleValueType (types.listOf singleValueType)));
        options = {
          sieve_plugins = mkOption {
            default = null;
            example = [ "sieve_extprograms" ];
            description = "Sieve plugins to load";
            type = types.nullOr (types.listOf types.str);
          };

          sieve_extensions = mkOption {
            default = null;
            description = "Sieve extensions to enable in user scripts";
            example = [
              "+notify"
              "+imapflags"
              "+vnd.dovecot.filter"
            ];
            type = types.nullOr (types.listOf types.str);
          };

          sieve_global_extensions = mkOption {
            default = null;
            example = [ "+vnd.dovecot.environment" ];
            description = "Sieve extensions to enable in global scripts";
            type = types.nullOr (types.listOf types.str);
          };

          sieve_pipe_bin_dir = mkOption {
            default = null;
            defaultText = "Directory containing the scripts defined in {option}`services.dovecot2.sieve.pipeBins`.";
            example = "/etc/dovecot/sieve-pipe";
            description = ''
              Directory containing programs available for use by the vnd.dovecot.pipe extension

              Unless you want to manage your own pipe-bins directory, it is
              recommended to add items to the
              {option}`services.dovecot2.sieve.pipeBins` list instead.
            '';
            type = types.nullOr (types.either types.path types.package);
          };
        };
      };
      default = { };
      example = literalExpression ''
        {
          sieve = "file:~/sieve;active=~/.dovecot.sieve";
        }
      '';
      description = ''
        Plugin settings for dovecot in general, e.g. `sieve`, `sieve_default`, etc.

        Some of the other knobs of this module will influence by default the
        plugin settings, but you can still override any plugin settings.

        If you override a plugin setting, its value is cleared and you generally
        have to copy over the defaults set by Dovecot in addition to the values
        you want to set. For some settings (like `sieve_extensions`) it is
        possible to avoid copying over the default by specifying a relative
        value (such as `[ "+notify" ]`) however.

        Plugin settings containing `null` are omitted from the generated
        configuration. This can be used to force a setting to the default value
        set by Dovecot, even its value would otherwise be set to some other
        value by a NixOS module.

        See https://doc.dovecot.org/settings/plugin/ for an incomplete list of
        all allowed settings.
      '';
    };

    imapsieve.mailbox = mkOption {
      default = [ ];
      description = "Configure Sieve filtering rules on IMAP actions";
      type = types.listOf (
        types.submodule (
          { config, ... }:
          {
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
                example = [
                  "COPY"
                  "APPEND"
                ];
                type = types.listOf (
                  types.enum [
                    "APPEND"
                    "COPY"
                    "FLAG"
                  ]
                );
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
          }
        )
      );
    };

    sieve = {
      scripts = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = "Sieve scripts to be executed. Key is a sequence, e.g. 'before2', 'after' etc.";
      };

      pipeBins = mkOption {
        default = [ ];
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
    security.pam.services.dovecot2 = mkIf cfg.enablePAM { };

    security.dhparams = mkIf (cfg.sslServerCert != null && cfg.enableDHE) {
      enable = true;
      params.dovecot2 = { };
    };

    services.dovecot2 = {
      protocols =
        optional cfg.enableImap "imap" ++ optional cfg.enablePop3 "pop3" ++ optional cfg.enableLmtp "lmtp";

      mailPlugins = mkIf cfg.enableQuota {
        globally.enable = [ "quota" ];
        perProtocol.imap.enable = [ "imap_quota" ];
      };

      pluginSettings = mkMerge [
        sieveScriptSettings
        imapSieveMailboxSettings
        (mkIf (cfg.sieve.pipeBins != [ ]) {
          sieve_plugins = [ "sieve_extprograms" ];
          sieve_global_extensions = [ "+vnd.dovecot.pipe" ];
          sieve_pipe_bin_dir = sievePipeBinScriptDirectory;
        })
        (mkIf (cfg.imapsieve.mailbox != [ ]) {
          sieve_plugins = [ "sieve_imapsieve" ];
        })
      ];
    };

    users.users =
      {
        dovenull = {
          uid = config.ids.uids.dovenull2;
          description = "Dovecot user for untrusted logins";
          group = "dovenull";
        };
      }
      // optionalAttrs (cfg.user == "dovecot2") {
        dovecot2 = {
          uid = config.ids.uids.dovecot2;
          description = "Dovecot user";
          group = cfg.group;
        };
      }
      // optionalAttrs (cfg.createMailUser && cfg.mailUser != null) {
        ${cfg.mailUser} = {
          description = "Virtual Mail User";
          isSystemUser = true;
        } // optionalAttrs (cfg.mailGroup != null) { group = cfg.mailGroup; };
      };

    users.groups =
      {
        dovenull.gid = config.ids.gids.dovenull2;
      }
      // optionalAttrs (cfg.group == "dovecot2") {
        dovecot2.gid = config.ids.gids.dovecot2;
      }
      // optionalAttrs (cfg.createMailUser && cfg.mailGroup != null) {
        ${cfg.mailGroup} = { };
      };

    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot = {
      aliases = [ "dovecot2.service" ];
      description = "Dovecot IMAP/POP3 server";
      documentation = [
        "man:dovecot(1)"
        "https://doc.dovecot.org"
      ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ cfg.configFile ];

      startLimitIntervalSec = 60; # 1 min
      serviceConfig = {
        Type = "notify";
        ExecStart = "${dovecotPkg}/sbin/dovecot -F";
        ExecReload = "${dovecotPkg}/sbin/doveadm reload";

        CapabilityBoundingSet = [
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_FOWNER"
          "CAP_NET_BIND_SERVICE"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_SYS_RESOURCE"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        OOMPolicy = "continue";
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = lib.mkDefault false;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        PrivateDevices = true;
        Restart = "on-failure";
        RestartSec = "1s";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = false; # sets sgid on maildirs
        RuntimeDirectory = [ "dovecot2" ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@privileged"
          "@chown @setuid capset chroot"
        ];
      };

      # When copying sieve scripts preserve the original time stamp
      # (should be 0) so that the compiled sieve script is newer than
      # the source file and Dovecot won't try to compile it.
      preStart =
        ''
          rm -rf ${stateDir}/sieve ${stateDir}/imapsieve
        ''
        + optionalString (cfg.sieve.scripts != { }) ''
          mkdir -p ${stateDir}/sieve
          ${concatStringsSep "\n" (
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
        + optionalString (cfg.imapsieve.mailbox != [ ]) ''
          mkdir -p ${stateDir}/imapsieve/{before,after}

          ${concatMapStringsSep "\n" (
            el:
            optionalString (el.before != null) ''
              cp -p ${el.before} ${stateDir}/imapsieve/before/${baseNameOf el.before}
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/before/${baseNameOf el.before}'
            ''
            + optionalString (el.after != null) ''
              cp -p ${el.after} ${stateDir}/imapsieve/after/${baseNameOf el.after}
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/after/${baseNameOf el.after}'
            ''
          ) cfg.imapsieve.mailbox}

          ${optionalString (
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
