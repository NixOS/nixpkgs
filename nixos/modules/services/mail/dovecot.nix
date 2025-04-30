{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    isInt
    isBool
    isString
    isAttrs
    isList
    isDerivation
    all
    splitString
    hasAttr
    elemAt
    length
    traceSeq
    attrValues
    attrsToList
    concatMapStringsSep
    concatStringsSep
    flatten
    imap1
    literalExpression
    mapAttrsToList
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    mkRemovedOptionModule
    optional
    optionals
    mkDefault
    optionalAttrs
    optionalString
    singleton
    types
    mkRenamedOptionModule
    nameValuePair
    mapAttrs'
    listToAttrs
    filter
    versionOlder
    versionAtLeast
    ;
  inherit (lib.versions) majorMinor;

  cfg = config.services.dovecot2;

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

  sievePlugins = concatStringsSep " " cfg.sieve.plugins;

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
      if (all (b: b) (map isString v)) then
        toOption indent n (concatStringsSep " " v)
      else
        map (formatKeyValue indent n) v
    else if isDerivation v then
      # when encountering a derivation, just use the output path instead of looping over it like a regular attrs
      toOption indent n v
    else if isAttrs v then
      let
        nSplit = splitString " " n;
        sectionType =
          # section.type or part before space in $n
          if (hasAttr "section" v) then
            if (hasAttr "type" v.section) then v.section.type else (elemAt nSplit 0)
          else
            (elemAt nSplit 0);
        sectionName =
          # section.name, part after space in $n, or unnamed
          if (hasAttr "section" v) && (hasAttr "name" v.section) then
            v.section.name
          else
            (if (length nSplit == 2) then (elemAt nSplit 1) else "");
      in
      concatStringsSep "\n" (
        [ "${indent}${sectionType} ${sectionName}${if sectionName != "" then " " else ""}{" ]
        ++ (mapAttrsToList (formatKeyValue "${indent}  ") (removeAttrs v [ "section" ]))
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
      (optional (configVersion != null) (formatKeyValue "" "dovecot_config_version" configVersion))
      ++ (optional (storageVersion != null) (formatKeyValue "" "dovecot_storage_version" storageVersion))
      ++ (optionals (cfg.includeFiles != [ ]) (map (f: "!include ${f}") cfg.includeFiles))
      ++ flatten (mapAttrsToList (formatKeyValue "") remainingSettings)
      ++ singleton cfg.extraConfig
    );

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
  imports =
    [
      (mkRemovedOptionModule [
        "services"
        "dovecot2"
        "modules"
      ] "Now need to use `environment.systemPackages` to load additional Dovecot modules")
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
      ] "Use `settings.mail_location` for Dovecot 2.3, `settings.mail_home` for 2.4.")
      (mkRenamedOptionModule
        [ "services" "dovecot2" "sieveScripts" ]
        [ "services" "dovecot2" "sieve" "scripts" ]
      )
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
        [ "pluginSettings" ]
        [ "enableQuota" ]
        [ "quotaPort" ]
        [ "quotaGlobalPerUser" ]
      ]
    );

  options.services.dovecot2 = {
    enable = mkEnableOption "the dovecot 2.x POP3/IMAP server";

    package = mkPackageOption pkgs "dovecot" {
      default = [
        (if versionAtLeast config.system.stateVersion "25.11" then pkgs.dovecot else pkgs.dovecot_2_3)
      ];
    };

    settings = mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          let
            atom = [
              int
              str
              bool
              (lazyAttrsOf settingsType)
            ];
            settingsType = nullOr (
              oneOf (
                atom
                ++ [
                  (listOf (oneOf atom))
                ]
              )
            );
          in
          settingsType;
      };
      description = ''
        Dovecot configuration, see <https://doc.dovecot.org/2.4.0/core/summaries/settings.html#all-dovecot-settings>
        for all available options.

        Note that you risk overriding values set by the other services.dovecot2.* options if you use them in combination with services.dovecot2.settings.
      '';
      example = {
        protocols = [
          "imap"
          "submission"
          "lmtp"
        ];
        mail_driver = "maildir";
        "namespace inbox" = {
          inbox = true;
          separator = "/";
        };
        service = [
          {
            section.name = "imap";
            process_min_avail = 1;
            client_limit = 100;
            "inet_listener imap".port = 31143;
            "inet_listener imaps".port = 31993;
          }
          {
            section.name = "lmtp";
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

    enablePop3 = mkEnableOption "starting the POP3 listener (when Dovecot is enabled)";

    enableImap = mkEnableOption "starting the IMAP listener (when Dovecot is enabled)" // {
      default = true;
    };

    enableLmtp = mkEnableOption "starting the LMTP listener (when Dovecot is enabled)";

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

    imapsieve.mailbox = mkOption {
      default = [ ];
      description = "Configure Sieve filtering rules on IMAP actions.";
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
      plugins = mkOption {
        default = [ ];
        example = [ "sieve_extprograms" ];
        description = "Sieve plugins to load";
        type = types.listOf types.str;
      };

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

    security.dhparams = mkIf cfg.enableDHE {
      enable = true;
      params.dovecot2 = { };
    };

    services.dovecot2.settings =
      # options shared between 2.3 and 2.4 (mostly)
      {
        dovecot_config_version = mkIf (versionAtLeast (majorMinor cfg.package.version) "2.4") cfg.package.version;
        dovecot_storage_version = mkIf (versionAtLeast (majorMinor cfg.package.version) "2.4") cfg.package.version;
        base_dir = mkDefault baseDir;
        sendmail_path = mkDefault "/run/wrappers/bin/sendmail";
        mail_plugin_dir = mkDefault "/run/current-system/sw/lib/dovecot/modules";

        default_internal_user = mkDefault cfg.user;
        default_internal_group = mkDefault cfg.group;

        maildir_copy_with_hardlinks = mkDefault true;
        pop3_uidl_format =
          if (versionAtLeast (majorMinor cfg.package.version) "2.4") then
            mkDefault "%{uidvalidity}%{uid}"
          else
            mkDefault "%08Xv%08Xu";

        auth_mechanisms = mkDefault "plain login";
        "service auth" = {
          user = "root";
        };

        protocols = mkDefault (
          optional cfg.enableImap "imap" ++ optional cfg.enablePop3 "pop3" ++ optional cfg.enableLmtp "lmtp"
        );

        "namespace inbox" = mkIf (cfg.mailboxes != { }) (
          {
            inbox = mkDefault true;
          }
          // builtins.listToAttrs (
            map (m: {
              name = "mailbox \"${m.name}\"";
              value = {
                inherit (m) auto autoexpunge;
                special_use = "\\${m.specialUse}";
              };
            }) (attrValues cfg.mailboxes)
          )
        );

        mail_plugins = mkDefault "$mail_plugins ${concatStringsSep " " cfg.mailPlugins.globally.enable}";
      }
      // optionalAttrs (cfg.mailPlugins.perProtocol != { }) (
        listToAttrs (
          map (m: {
            name = "protocol ${elemAt (splitString "." m.name) 0}";
            value.mail_plugins = "$mail_plugins ${concatStringsSep " " m.value.enable}";
          }) (attrsToList cfg.mailPlugins.perProtocol)
        )
      )
      // (
        # these options differ quite a bit between 2.3 and 2.4, which is why they were split up here
        if (versionAtLeast (majorMinor cfg.package.version) "2.4") then
          {
            mail_home = mkDefault "/var/spool/mail/%{user}";

            ssl_server_dh_file = mkIf (cfg.enableDHE != null) (
              mkDefault "${config.security.dhparams.params.dovecot2.path}"
            );

            "passdb pam" = mkIf cfg.enablePAM (mkDefault {
              driver = "pam";
              args = "${optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2";
            });

            "userdb pam" = mkIf cfg.enablePAM (mkDefault {
              driver = "passwd";
            });
          }
          // lib.mapAttrs (_: mkDefault) (
            (optionalAttrs (cfg.imapsieve.mailbox != [ ]) imapSieveMailboxSettings)
            // (optionalAttrs (cfg.sieve.scripts != { }) sieveScriptSettings)
            // (optionalAttrs (cfg.sieve.plugins != [ ]) { "sieve_plugins" = sievePlugins; })
            // (optionalAttrs (cfg.sieve.extensions != [ ]) {
              "sieve_extensions" = concatStringsSep " " cfg.sieve.extensions;
            })
            // (optionalAttrs (cfg.sieve.globalExtensions != [ ]) {
              "sieve_global_extensions" = concatStringsSep " " cfg.sieve.globalExtensions;
            })
            // (optionalAttrs (cfg.sieve.pipeBins != [ ]) {
              "sieve_pipe_bin_dir" = sievePipeBinScriptDirectory;
            })
          )
        else
          {
            mail_location = mkDefault "maildir:/var/spool/mail/%u";

            ssl_dh = mkIf (cfg.enableDHE != null) (
              mkDefault "<${config.security.dhparams.params.dovecot2.path}"
            );

            passdb = mkIf cfg.enablePAM (mkDefault {
              driver = "pam";
              args = "${optionalString cfg.showPAMFailure "failure_show_msg=yes"} dovecot2";
            });

            userdb = mkIf cfg.enablePAM (mkDefault {
              driver = "passwd";
            });

            plugin = lib.mapAttrs (_: mkDefault) (
              (optionalAttrs (cfg.imapsieve.mailbox != [ ]) imapSieveMailboxSettings)
              // (optionalAttrs (cfg.sieve.scripts != { }) sieveScriptSettings)
              // (optionalAttrs (cfg.sieve.plugins != [ ]) { "sieve_plugins" = sievePlugins; })
              // (optionalAttrs (cfg.sieve.extensions != [ ]) {
                "sieve_extensions" = concatStringsSep " " (map (el: "+${el}") cfg.sieve.extensions);
              })
              // (optionalAttrs (cfg.sieve.globalExtensions != [ ]) {
                "sieve_global_extensions" = concatStringsSep " " (map (el: "+${el}") cfg.sieve.globalExtensions);
              })
              // (optionalAttrs (cfg.sieve.pipeBins != [ ]) {
                "sieve_pipe_bin_dir" = sievePipeBinScriptDirectory;
              })
            );
          }
      );

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
      // (optionalAttrs (cfg.settings ? mail_uid && cfg.settings.mail_uid != null && cfg.createMailUser) {
        ${cfg.settings.mail_uid} =
          {
            description = "Virtual Mail User";
            isSystemUser = true;
          }
          // optionalAttrs (cfg.settings ? mail_gid && cfg.settings.mail_gid != null) {
            group = cfg.settings.mail_gid;
          };
      });

    users.groups =
      {
        dovenull.gid = config.ids.gids.dovenull2;
      }
      // optionalAttrs (cfg.group == "dovecot2") {
        dovecot2.gid = config.ids.gids.dovecot2;
      }
      // (optionalAttrs (cfg.settings ? mail_gid && cfg.settings.mail_gid != null && cfg.createMailUser) {
        ${cfg.settings.mail_gid} = { };
      });

    environment.etc."dovecot/dovecot.conf".source = cfg.configFile;

    systemd.services.dovecot2 = {
      description = "Dovecot IMAP/POP3 server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.configFile
      ];

      startLimitIntervalSec = 60; # 1 min
      serviceConfig = {
        Type = "notify";
        ExecStart = "${lib.getExe cfg.package} -F";
        ExecReload = "${lib.getExe' cfg.package "doveadm"} reload";
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
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/before/${baseNameOf el.before}'
            ''
            + optionalString (el.after != null) ''
              cp -p ${el.after} ${stateDir}/imapsieve/after/${baseNameOf el.after}
              ${pkgs.dovecot_pigeonhole}/bin/sievec '${stateDir}/imapsieve/after/${baseNameOf el.after}'
            ''
          ) cfg.imapsieve.mailbox}

          ${optionalString (
            cfg.settings ? mail_uid && cfg.settings.mail_uid != null && cfg.settings.mail_gid != null
          ) "chown -R '${cfg.settings.mail_uid}:${cfg.settings.mail_gid}' '${stateDir}/imapsieve'"}
        '';
    };

    environment.systemPackages = [ cfg.package ];

    warnings = optional (versionOlder config.system.stateVersion "25.11") ''
      While Dovecot 2.3 is not yet deprecated or EOL,
      there is a newer version available in Nixpkgs (Dovecot 2.4).
      Check https://doc.dovecot.org/2.4.0/installation/upgrade/2.3-to-2.4.html
      before upgrading.'';

    assertions = [
      {
        assertion = cfg.showPAMFailure -> cfg.enablePAM;
        message = "dovecot is configured with showPAMFailure while enablePAM is disabled";
      }
      {
        assertion =
          cfg.sieve.scripts != { } -> (cfg.settings.mail_uid != null && cfg.settings.mail_gid != null);
        message = "dovecot requires settings.mail_uid and settings.mail_gid to be set when `sieve.scripts` is set";
      }
    ];
  };

  meta.maintainers = [ lib.maintainers.dblsaiko ];
}
