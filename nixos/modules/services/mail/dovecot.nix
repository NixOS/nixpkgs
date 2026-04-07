{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    all
    attrsToList
    concatMapStringsSep
    concatStringsSep
    elemAt
    filter
    flatten
    imap1
    isAttrs
    isBool
    isDerivation
    isInt
    isList
    isPath
    isString
    listToAttrs
    literalExpression
    mapAttrs'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    nameValuePair
    optional
    optionalAttrs
    optionalString
    optionals
    singleton
    splitString
    traceSeq
    types
    versionAtLeast
    versionOlder
    ;

  cfg = config.services.dovecot2;

  baseDir = "/run/dovecot2";
  stateDir = "/var/lib/dovecot";

  sievec = lib.getExe' cfg.package.passthru.dovecot_pigeonhole "sievec";

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

  sievePipeBinScriptDirectory = pkgs.linkFarm "sieve-pipe-bins" (
    map (el: {
      name = builtins.unsafeDiscardStringContext (baseNameOf el);
      path = el;
    }) cfg.sieve.pipeBins
  );

  yesOrNo = v: if v then "yes" else "no";

  toOption =
    i: n: v:
    "${i}${toString n} = ${v}";

  formatKeyValue =
    indent: n: v:
    if (v == null) then
      ""
    else if isInt v then
      toOption indent n (toString v)
    else if isBool v then
      toOption indent n (yesOrNo v)
    else if isString v then
      toOption indent n v
    else if isList v then
      if all isString v then
        toOption indent n (concatStringsSep " " v)
      else
        map (formatKeyValue indent n) v
    else if isPath v || isDerivation v then
      # paths -> copy to store
      # derivations -> just use output path instead of looping over the attrs
      toOption indent n "${v}"
    else if isAttrs v && v ? _section then
      let
        sectionType = v._section.type;
        sectionName = v._section.name;
        sectionTitle = concatStringsSep " " (
          filter (s: s != null) [
            sectionType
            sectionName
          ]
        );
      in
      concatStringsSep "\n" (
        [
          "${indent}${sectionTitle} {"
        ]
        ++ (mapAttrsToList (formatKeyValue "${indent}  ") (removeAttrs v [ "_section" ]))
        ++ [ "${indent}}" ]
      )
    else if isAttrs v then
      concatStringsSep "\n" (
        [
          "${indent}${n} {"
        ]
        ++ (mapAttrsToList (formatKeyValue "${indent}  ") v)
        ++ [ "${indent}}" ]
      )
    else
      throw (traceSeq v "services.dovecot2.settings: unexpected type");

  doveConf =
    let
      configVersion = cfg.settings.dovecot_config_version or null;
      storageVersion = cfg.settings.dovecot_storage_version or null;
      remainingSettings = builtins.removeAttrs cfg.settings [
        "dovecot_config_version"
        "dovecot_storage_version"
      ];
    in
    concatStringsSep "\n" (
      optional (configVersion != null) (formatKeyValue "" "dovecot_config_version" configVersion)
      ++ optional (storageVersion != null) (formatKeyValue "" "dovecot_storage_version" storageVersion)
      ++ optionals (cfg.includeFiles != [ ]) (map (f: "!include ${f}") cfg.includeFiles)
      ++ flatten (mapAttrsToList (formatKeyValue "") remainingSettings)
    );

  isPre24 = versionOlder cfg.package.version "2.4";
in
{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "modules"
    ] "Now need to use `environment.systemPackages` to load additional Dovecot modules")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "enablePop3"
    ] "Set 'services.dovecot2.settings.protocols.pop3 = true/false;' instead.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "enableImap"
    ] "Set 'services.dovecot2.settings.protocols.imap = true/false;' instead.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "enableLmtp"
    ] "Set 'services.dovecot2.settings.protocols.lmtp = true/false;' instead.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "sslServerCert"
    ] "Use `settings.ssl_cert` for Dovecot 2.3, `settings.ssl_server_cert_file` for 2.4.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "sslServerKey"
    ] "Use `settings.ssl_key` for Dovecot 2.3, `settings.ssl_server_key_file` for 2.4.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "sslCACert"
    ] "Use `settings.ssl_ca` for Dovecot 2.3, `settings.ssl_server_ca_file` for 2.4.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "mailLocation"
    ] "Use `settings.mail_location` for Dovecot 2.3, `settings.mail_path` for 2.4.")
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "enableDHE"
    ] "Use ECDHE instead, or use recommended parameters from RFC7919.")
    (mkRenamedOptionModule
      [ "services" "dovecot2" "sieveScripts" ]
      [ "services" "dovecot2" "sieve" "scripts" ]
    )
    (mkRemovedOptionModule [
      "services"
      "dovecot2"
      "sieve"
      "plugins"
    ] "Set 'services.dovecot2.settings.plugin.sieve_plugins' instead.")
    (mkRenamedOptionModule
      [ "services" "dovecot2" "mailUser" ]
      [ "services" "dovecot2" "settings" "mail_uid" ]
    )
    (mkRenamedOptionModule
      [ "services" "dovecot2" "mailGroup" ]
      [ "services" "dovecot2" "settings" "mail_gid" ]
    )
    (mkRenamedOptionModule
      [ "services" "dovecot2" "protocols" ]
      [ "services" "dovecot2" "settings" "protocols" ]
    )
  ]
  ++ (
    let
      basePath = [
        "services"
        "dovecot2"
      ];
      mkRemovedOptions =
        list:
        map (
          name: mkRemovedOptionModule (basePath ++ name) "Please use services.dovecot2.settings instead."
        ) list;
    in
    mkRemovedOptions [
      [ "extraConfig" ]
      [ "mailboxes" ]
      [ "pluginSettings" ]
      [ "enableQuota" ]
      [ "quotaPort" ]
      [ "quotaGlobalPerUser" ]
    ]
  );

  options.services.dovecot2 = {
    enable = mkEnableOption "the dovecot 2.x POP3/IMAP server";

    package = mkPackageOption pkgs "dovecot" { } // {
      default =
        if versionAtLeast config.system.stateVersion "26.05" then pkgs.dovecot else pkgs.dovecot_2_3;
      defaultText = lib.literalExpression ''if versionAtLeast config.system.stateVersion "26.05" then pkgs.dovecot else pkgs.dovecot_2_3'';
    };

    settings = mkOption {
      default = { };
      type =
        let
          inherit (lib.types)
            attrsOf
            path
            bool
            int
            listOf
            nonEmptyListOf
            nonEmptyStr
            nullOr
            oneOf
            str
            submodule
            ;
          inherit (lib.lists) last dropEnd;

          sectionBase =
            fixed:
            { name, options, ... }:
            let
              # if the current name is a list (matches '[definition .*]') -> get
              # name' from _module.args.loc & use it for {type,name}Default
              name' =
                if (builtins.match "[[]definition .*].*" name) == null then
                  name
                else
                  last (dropEnd 3 options._module.args.loc);

              # split name' on the first space
              splits = builtins.match "([^ ]+) (.+)" name';
              typeDefault = if splits == null then name' else builtins.elemAt splits 0;
              nameDefault = if splits == null then null else builtins.elemAt splits 1;
            in
            {
              options = {
                _section = {
                  type = mkOption {
                    description = "Section type, mandatory for every section.";
                    type = nonEmptyStr;
                    default = typeDefault;

                    readOnly = fixed;
                    internal = fixed;
                  };
                  name = mkOption {
                    description = "Section name, comes after section type & is optional in some cases.";
                    type = nullOr nonEmptyStr;
                    default = nameDefault;

                    readOnly = fixed;
                    internal = fixed;
                  };
                };
              };

              freeformType = attrsOf valueType;
            };
          section = submodule (sectionBase false);
          fixedSectionWith =
            extraModule:
            submodule [
              (sectionBase true)
              extraModule
            ];

          primitiveType = oneOf [
            int
            str
            bool
            # path must order before section, otherwise the latter will
            # interpret path literals as a module path to load
            path
            section
          ];

          valueType =
            nullOr (oneOf [
              primitiveType
              (nonEmptyListOf primitiveType)
            ])
            // {
              description = "Dovecot config value";
            };

          booleanList = oneOf [
            (attrsOf bool)
            (listOf str)
          ];

          toplevel = submodule {
            options = {
              base_dir = mkOption {
                default = baseDir;
                description = ''
                  The base directory in which Dovecot should store runtime data.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#base_dir>.
                '';
                type = path;
              };

              sendmail_path = mkOption {
                default = "/run/wrappers/bin/sendmail";
                description = ''
                  The binary to use for sending email.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#sendmail_path>.
                '';
                type = path;
              };

              mail_plugin_dir = mkOption {
                default = "/run/current-system/sw/lib/dovecot/modules";
                description = ''
                  The directory in which to search for Dovecot mail plugins.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#mail_plugin_dir>.
                '';
                type = path;
              };

              default_internal_user = mkOption {
                default = "dovecot2";
                description = ''
                  Define the default internal user.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#default_internal_user>.
                '';
                type = str;
              };

              default_internal_group = mkOption {
                default = "dovecot2";
                description = ''
                  Define the default internal group.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#default_internal_group>.
                '';
                type = str;
              };

              maildir_copy_with_hardlinks = mkOption {
                default = true;
                description = ''
                  If enabled, copying of a message is done with hard links whenever possible.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#maildir_copy_with_hardlinks>.
                '';
                type = bool;
              };

              auth_mechanisms = mkOption {
                default = [
                  "plain"
                  "login"
                ];
                description = ''
                  Here you can supply a space-separated list of the authentication mechanisms you wish to use.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#auth_mechanisms>.
                '';
                type = booleanList;
              };

              "passdb pam" = mkOption {
                default = null;
                description = ''
                  Configuration for the PAM password database.

                  See <https://doc.dovecot.org/latest/core/config/auth/databases/pam.html>.
                '';
                type = nullOr (fixedSectionWith {
                  options = {
                    driver = mkOption {
                      default = if isPre24 then "pam" else null;
                      defaultText = literalExpression ''if isPre24 then "pam" else null'';
                      description = ''
                        The driver used for this password database.

                        See <https://doc.dovecot.org/latest/core/summaries/settings.html#passdb_driver>.
                      '';
                      type = nullOr str;
                    };

                    args = mkOption {
                      # set below in config
                      default = null;
                      defaultText = ''if isPre24 then [ "dovecot2" ] else null'';
                      description = ''
                        Arguments for the passdb backend.

                        This option is exclusive to Dovecot 2.3.

                        See <https://doc.dovecot.org/2.3/configuration_manual/authentication/password_databases_passdb/#passdb-setting>.
                      '';
                      type = nullOr (listOf str);
                    };

                    service_name = mkOption {
                      default = if isPre24 then null else "dovecot2";
                      defaultText = literalExpression ''if isPre24 then null else "dovecot2"'';
                      description = ''
                        The PAM service name to be used with the pam passdb.

                        This option is exclusive to Dovecot 2.4.

                        See <https://doc.dovecot.org/latest/core/summaries/settings.html#passdb_pam_service_name>.
                      '';
                      type = nullOr str;
                    };

                    failure_show_msg = mkOption {
                      default = if isPre24 then null else cfg.showPAMFailure;
                      defaultText = literalExpression "if isPre24 then null else config.services.dovecot2.showPAMFailure";
                      description = ''
                        Replace the default "Authentication failed" reply with PAM's failure.

                        This option is exclusive to Dovecot 2.4.

                        See <https://doc.dovecot.org/latest/core/summaries/settings.html#passdb_pam_failure_show_msg>.
                      '';
                      type = nullOr bool;
                    };
                  };
                });
              };

              "userdb passwd" = mkOption {
                default = null;
                description = ''
                  Configuration for the Passwd user database.

                  See <https://doc.dovecot.org/latest/core/config/auth/databases/passwd.html>.
                '';
                type = nullOr (fixedSectionWith {
                  options = {
                    driver = mkOption {
                      default = if isPre24 then "passwd" else null;
                      defaultText = literalExpression ''if isPre24 then "passwd" else null'';
                      description = ''
                        The driver used for this user database.

                        See <https://doc.dovecot.org/latest/core/summaries/settings.html#userdb_driver>.
                      '';
                      type = nullOr str;
                    };
                  };
                });
              };

              # 2.3-only options

              plugin = mkOption {
                default = null;
                description = "Plugin settings. This option is exclusive to Dovecot 2.3.";
                type = nullOr (fixedSectionWith {
                  options = {
                    sieve_pipe_bin_dir = mkOption {
                      default = null;
                      description = ''
                        Points to a directory where the plugin looks for programs (shell scripts) to execute directly and pipe messages to for the *vnd.dovecot.pipe* extension.

                        This option is exclusive to Dovecot 2.3.

                        See <https://doc.dovecot.org/2.3/configuration_manual/sieve/plugins/extprograms/#configuration>.
                      '';
                      type = nullOr path;
                    };

                    sieve_plugins = mkOption {
                      default = null;
                      description = ''
                        List of Sieve plugins to load.

                        This option is exclusive to Dovecot 2.3.

                        See <https://doc.dovecot.org/2.3/settings/pigeonhole/#pigeonhole_setting-sieve_plugins>.
                      '';
                      type = nullOr (listOf str);
                    };

                    sieve_extensions = mkOption {
                      default = null;
                      description = ''
                        The Sieve language extensions available to users.

                        This option is exclusive to Dovecot 2.3.

                        See <https://doc.dovecot.org/2.3/settings/pigeonhole/#pigeonhole_setting-sieve_extensions>.
                      '';
                      type = nullOr (listOf str);
                    };

                    sieve_global_extensions = mkOption {
                      default = null;
                      description = ''
                        Which Sieve language extensions are **only** available in global scripts.

                        This option is exclusive to Dovecot 2.3.

                        See <https://doc.dovecot.org/2.3/settings/pigeonhole/#pigeonhole_setting-sieve_global_extensions>.
                      '';
                      type = nullOr (listOf str);
                    };
                  };
                });
              };

              # 2.4-only options

              sieve_script_bin_path = mkOption {
                default = if isPre24 then null else "/tmp/dovecot-%{user|username|lower}";
                defaultText = literalExpression ''
                  if isPre24
                  then null
                  else "/tmp/dovecot-%{user|username|lower}"
                '';
                description = ''
                  Points to the directory where the compiled binaries for this script location are stored. This directory is created automatically if possible.

                  This option is exclusive to Dovecot 2.4.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_script_bin_path>.
                '';
                type = nullOr str;
              };

              sieve_pipe_bin_dir = mkOption {
                default = null;
                description = ''
                  Points to a directory where the plugin looks for programs (shell scripts) to execute directly and pipe messages to for the *vnd.dovecot.pipe* extension.

                  This option is exclusive to Dovecot 2.4.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_plugins>.
                '';
                type = nullOr path;
              };

              sieve_plugins = mkOption {
                default = null;
                description = ''
                  List of Sieve plugins to load.

                  This option is exclusive to Dovecot 2.4.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_plugins>.
                '';
                type = nullOr booleanList;
              };

              sieve_global_extensions = mkOption {
                default = null;
                description = ''
                  Which Sieve language extensions are **only** available in global scripts.

                  This option is exclusive to Dovecot 2.4.

                  See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_global_extensions>.
                '';
                type = nullOr booleanList;
              };
            };

            freeformType = attrsOf valueType;
          };
        in
        toplevel;
      description = ''
        Dovecot configuration, see <https://doc.dovecot.org/latest/core/summaries/settings.html#all-dovecot-settings>
        for all available options.

        For information on the configuration structure, see <https://doc.dovecot.org/latest/core/settings/syntax.html>.

        ::: {.warning}
        Explicit settings in [{option}`services.dovecot2.settings`](#opt-services.dovecot2.settings) can silently override values set by other `services.dovecot2.*` options.
        :::
      '';
      example = {
        protocols = {
          imap = true;
          submission = true;
          lmtp = true;
        };

        mail_driver = "maildir";
        mail_home = "/var/vmail/%{user | domain}/%{user | username}";
        mail_path = "~/mail";

        "namespace inbox" = {
          inbox = true;
          separator = "/";
        };
        service = [
          {
            _section.name = "imap";
            process_min_avail = 1;
            client_limit = 100;
            "inet_listener imap".port = 31143;
            "inet_listener imaps".port = 31993;
          }
          {
            _section.name = "lmtp";
            user = "dovemail";
            "unix_listener lmtp" = {
              mode = "0660";
              user = "postfix";
            };
          }
        ];
        "protocol imap".mail_plugins = {
          imap_sieve = true;
          imap_filter_sieve = true;
        };
        mail_attribute."dict file" = {
          path = "%{home}/dovecot-attributes";
        };
      };
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
      apply = v: if v != null then v else pkgs.writeText "dovecot.conf" doveConf;
    };

    includeFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = "Files to include in the Dovecot config file using !include directives.";
      example = [ "/foo/bar/extraDovecotConfig.conf" ];
    };

    createMailUser =
      mkEnableOption ''
        automatically creating the user
        given in {option}`services.dovecot2.settings.mail_uid` and the group
        given in {option}`services.dovecot2.settings.mail_gid`''
      // {
        default = true;
      };

    enablePAM = mkEnableOption "creating a own Dovecot PAM service and configure PAM user logins";

    showPAMFailure = mkEnableOption "showing the PAM failure message on authentication error (useful for OTPW)";

    imapsieve.mailbox = mkOption {
      default = [ ];
      description = ''
        Configure Sieve filtering rules on IMAP actions

        ::: {.note}
        This option is no longer used starting from Dovecot version 2.4.
        :::
      '';
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
      extensions = mkOption {
        default = [ ];
        description = "Sieve extensions for use in user scripts";
        example = [
          "notify"
          "imapflags"
          "vnd.dovecot.filter"
        ];
        type = types.listOf types.str;
      };

      globalExtensions = mkOption {
        default = [ ];
        example = [ "vnd.dovecot.environment" ];
        description = "Sieve extensions for use in global scripts";
        type = types.listOf types.str;
      };

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

    services.dovecot2 = {
      sieve.globalExtensions = mkIf isPre24 (optional (cfg.sieve.pipeBins != [ ]) "vnd.dovecot.pipe");

      settings = mkMerge [
        # these options differ quite a bit between 2.3 and 2.4, which is why they were split up here
        # for pre-2.4:
        (mkIf isPre24 {
          "passdb pam" = mkIf cfg.enablePAM {
            args = mkMerge (
              optional cfg.showPAMFailure "failure_show_msg=yes" ++ singleton (lib.mkAfter [ "dovecot2" ])
            );
          };

          "userdb passwd" = mkIf cfg.enablePAM { };

          mail_plugins = mkDefault "$mail_plugins ${concatStringsSep " " cfg.mailPlugins.globally.enable}";

          plugin = mkMerge [
            sieveScriptSettings
            imapSieveMailboxSettings
            {
              sieve_plugins = mkMerge [
                (mkIf (cfg.imapsieve.mailbox != [ ]) [ "sieve_imapsieve" ])
                (mkIf (cfg.sieve.pipeBins != [ ]) [ "sieve_extprograms" ])
              ];
              sieve_pipe_bin_dir =
                mkIf (cfg.sieve.pipeBins != [ ]) # .
                  sievePipeBinScriptDirectory;
              sieve_extensions =
                mkIf (cfg.sieve.extensions != [ ]) # .
                  (map (el: "+${el}") cfg.sieve.extensions);
              sieve_global_extensions =
                mkIf (cfg.sieve.globalExtensions != [ ]) # .
                  (map (el: "+${el}") cfg.sieve.globalExtensions);
            }
          ];
        })
        (mkIf (isPre24 && cfg.mailPlugins.perProtocol != { } || cfg.mailPlugins.globally.enable != [ ]) (
          listToAttrs (
            map (m: {
              name = "protocol ${elemAt (splitString "." m.name) 0}";
              value.mail_plugins = "$mail_plugins ${
                concatStringsSep " " (m.value.enable ++ cfg.mailPlugins.globally.enable)
              }";
            }) (attrsToList cfg.mailPlugins.perProtocol)
          )
        ))
        # for 2.4:
        (mkIf (!isPre24) {
          "passdb pam" = mkIf cfg.enablePAM { };
          "userdb passwd" = mkIf cfg.enablePAM { };

          sieve_plugins = mkIf (cfg.sieve.pipeBins != [ ]) {
            "sieve_extprograms" = true;
          };

          sieve_global_extensions = mkIf (cfg.sieve.pipeBins != [ ]) {
            "vnd.dovecot.pipe" = true;
          };

          sieve_pipe_bin_dir = mkIf (cfg.sieve.pipeBins != [ ]) sievePipeBinScriptDirectory;
        })
      ];
    };

    users.users = {
      dovenull = {
        uid = config.ids.uids.dovenull2;
        description = "Dovecot user for untrusted logins";
        group = "dovenull";
      };
    }
    // optionalAttrs (cfg.settings.default_internal_user == "dovecot2") {
      dovecot2 = {
        uid = config.ids.uids.dovecot2;
        description = "Dovecot user";
        group = cfg.settings.default_internal_group;
      };
    }
    // optionalAttrs (cfg.settings.mail_uid or null != null && cfg.createMailUser) {
      ${cfg.settings.mail_uid} = {
        description = "Virtual Mail User";
        isSystemUser = true;
      }
      // optionalAttrs (cfg.settings.mail_gid or null != null) {
        group = cfg.settings.mail_gid;
      };
    };

    users.groups = {
      dovenull.gid = config.ids.gids.dovenull2;
    }
    // optionalAttrs (cfg.settings.default_internal_group == "dovecot2") {
      dovecot2.gid = config.ids.gids.dovecot2;
    }
    // optionalAttrs (cfg.settings.mail_gid or null != null && cfg.createMailUser) {
      ${cfg.settings.mail_gid} = { };
    };

    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot = {
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
        ExecStart = "${lib.getExe cfg.package} -F";
        ExecReload = "${lib.getExe' cfg.package "doveadm"} reload";

        CapabilityBoundingSet = [
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_FOWNER"
          "CAP_KILL" # Required for child process management
          "CAP_NET_BIND_SERVICE"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_SYS_RESOURCE"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = false; # e.g for sendmail
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
          "AF_NETLINK" # e.g. getifaddrs in sieve handling
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
      preStart = ''
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
            ${sievec} '${stateDir}/sieve/${to}'
          '') cfg.sieve.scripts
        )}
        ${optionalString (
          cfg.settings ? mail_uid && cfg.settings.mail_uid != null && cfg.settings.mail_gid != null
        ) "chown -R '${cfg.settings.mail_uid}:${cfg.settings.mail_gid}' '${stateDir}/sieve'"}
      ''
      + optionalString (cfg.imapsieve.mailbox != [ ]) ''
        mkdir -p ${stateDir}/imapsieve/{before,after}

        ${concatMapStringsSep "\n" (
          el:
          optionalString (el.before != null) ''
            cp -p ${el.before} ${stateDir}/imapsieve/before/${baseNameOf el.before}
            ${sievec} '${stateDir}/imapsieve/before/${baseNameOf el.before}'
          ''
          + optionalString (el.after != null) ''
            cp -p ${el.after} ${stateDir}/imapsieve/after/${baseNameOf el.after}
            ${sievec} '${stateDir}/imapsieve/after/${baseNameOf el.after}'
          ''
        ) cfg.imapsieve.mailbox}

        ${optionalString (
          cfg.settings ? mail_uid && cfg.settings.mail_uid != null && cfg.settings.mail_gid != null
        ) "chown -R '${cfg.settings.mail_uid}:${cfg.settings.mail_gid}' '${stateDir}/imapsieve'"}
      '';
    };

    environment.systemPackages = [ cfg.package ];

    warnings = optional isPre24 ''
      While Dovecot 2.3 is not yet deprecated or EOL,
      there is a newer version available in Nixpkgs (Dovecot 2.4).
      Check https://doc.dovecot.org/latest/installation/upgrade/2.3-to-2.4.html
      before upgrading.
    '';

    assertions = [
      {
        assertion = isPre24 || cfg.settings.dovecot_config_version != null;
        message = ''
          services.dovecot2: Since Dovecot 2.4, the option 'services.dovecot2.settings.dovecot_config_version' must be explicitly set.
           To retain compatibility with future updates, set the following and manually update as needed.

               services.dovecot2.settings.dovecot_config_version = "${cfg.package.version}";

           Alternatively, you can automatically update to newer versions of the configuration format, which might break compatibility with future updates.

               services.dovecot2.settings.dovecot_config_version = config.services.dovecot2.package.version;

           See <https://doc.dovecot.org/latest/installation/upgrade/2.3-to-2.4.html>.
        '';
      }
      {
        assertion = isPre24 || cfg.settings.dovecot_storage_version != null;
        message = ''
          services.dovecot2: Since Dovecot 2.4, the option 'services.dovecot2.settings.dovecot_storage_version' must be explicitly set.
           Set it to the oldest version the storage should stay compatible with, for example the following for the currently selected version.

               services.dovecot2.settings.dovecot_storage_version = "${cfg.package.version}";

           See <https://doc.dovecot.org/latest/installation/upgrade/2.3-to-2.4.html>.
        '';
      }
      {
        assertion = isPre24 || cfg.imapsieve.mailbox == [ ];
        message = "since Dovecot 2.4, the `imapsieve.mailbox` option is no longer used in the NixOS module, please use the `settings` option instead.";
      }
      {
        assertion = isPre24 || cfg.sieve.scripts == { };
        message = ''
          services.dovecot2: Since Dovecot 2.4, the option 'services.dovecot2.sieve.scripts' is no longer valid, but it is set.
           See <https://doc.dovecot.org/latest/core/plugins/sieve.html>.
        '';
      }
      {
        assertion = isPre24 || cfg.sieve.extensions == [ ];
        message = ''
          services.dovecot2: Since Dovecot 2.4, the option 'services.dovecot2.sieve.extensions' is no longer valid, but it is set.
           Set 'services.dovecot2.settings.sieve_extensions' instead.
           See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_extensions>.
        '';
      }
      {
        assertion = isPre24 || cfg.sieve.globalExtensions == [ ];
        message = ''
          services.dovecot2: Since Dovecot 2.4, the option 'services.dovecot2.sieve.globalExtensions' is no longer valid, but it is set.
           Set 'services.dovecot2.settings.sieve_global_extensions' instead.
           See <https://doc.dovecot.org/latest/core/summaries/settings.html#sieve_global_extensions>.
        '';
      }
      {
        assertion =
          isPre24
          ||
            # this is the default value for cfg.mailPlugins
            cfg.mailPlugins == {
              globally = {
                enable = [ ];
              };
              perProtocol = { };
            };
        message = "since Dovecot 2.4, the `mailPlugins` option is no longer used in the NixOS module, please use the `settings` option instead.";
      }
      {
        assertion = cfg.showPAMFailure -> cfg.enablePAM;
        message = "dovecot is configured with showPAMFailure while enablePAM is disabled";
      }
      {
        assertion =
          cfg.sieve.scripts != { } -> (cfg.settings.mail_uid != null && cfg.settings.mail_gid != null);
        message = "dovecot requires settings.mail_uid and settings.mail_gid to be set when `sieve.scripts` is set";
      }
      {
        assertion = config.systemd.services ? dovecot2 == false;
        message = ''
          Your configuration sets options on the `dovecot2` systemd service. These have no effect until they're migrated to the `dovecot` service.
        '';
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [
    dblsaiko
    jappie3
    prince213
  ];
}
