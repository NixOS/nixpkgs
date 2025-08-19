{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.auditd;

  settingsType =
    with lib.types;
    nullOr (oneOf [
      bool
      nonEmptyStr
      path
      int
    ]);

  pluginOptions = lib.types.submodule {
    options = {
      active = lib.mkEnableOption "Whether to enable this plugin";
      direction = lib.mkOption {
        type = lib.types.enum [
          "in"
          "out"
        ];
        default = "out";
        description = ''
          The option is dictated by the plugin. In or out are the only choices.
          You cannot make a plugin operate in a way it wasn't  designed just by
          changing this option. This option is to give a clue to the event dispatcher
          about which direction events flow.

          ::: {.note}
          Inbound events are not supported yet.
          :::
        '';
      };
      path = lib.mkOption {
        type = lib.types.path;
        description = "This is the absolute path to the plugin executable.";
      };
      type = lib.mkOption {
        type = lib.types.enum [ "always" ];
        readOnly = true;
        default = "always";
        description = ''
          This tells the dispatcher how the plugin wants to be run. There is only
          one valid option, `always`, which means the plugin is external and should
          always be run. The default is `always` since there are no more builtin plugins.
        '';
      };
      args = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.nonEmptyStr);
        default = null;
        description = ''
          This allows you to pass arguments to the child program.
          Generally plugins do not take arguments and have their own
          config file that instructs them how they should be configured.
        '';
      };
      format = lib.mkOption {
        type = lib.types.enum [
          "binary"
          "string"
        ];
        default = "string";
        description = ''
          Binary passes the data exactly as the audit event dispatcher gets it from
          the audit daemon. The string option tells the dispatcher to completely change
          the event into a string suitable for parsing with the audit parsing library.
        '';
      };
      settings = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            freeformType = lib.types.attrsOf settingsType;
          }
        );
        default = null;
        description = "Plugin-specific config file to link to /etc/audit/<plugin>.conf";
      };
    };
  };

  prepareConfigValue =
    v:
    if lib.isBool v then
      (if v then "yes" else "no")
    else if lib.isList v then
      lib.concatStringsSep " " (map prepareConfigValue v)
    else
      builtins.toString v;
  prepareConfigText =
    conf:
    lib.concatLines (
      lib.mapAttrsToList (k: v: if v == null then "#${k} =" else "${k} = ${prepareConfigValue v}") conf
    );
in
{
  options.security.auditd = {
    enable = lib.mkEnableOption "the Linux Audit daemon";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf settingsType;
        options = {
          # space_left needs to be larger than admin_space_left, yet they default to be the same if left open.
          space_left = lib.mkOption {
            type = lib.types.either lib.types.int (lib.types.strMatching "[0-9]+%");
            default = 75;
            description = ''
              If the free space in the filesystem containing log_file drops below this value, the audit daemon takes the action specified by
              {option}`space_left_action`. If the value of {option}`space_left` is specified as a whole number, it is interpreted as an absolute size in mebibytes
              (MiB). If the value is specified as a number between 1 and 99 followed by a percentage sign (e.g., 5%), the audit daemon calculates
              the absolute size in megabytes based on the size of the filesystem containing {option}`log_file`. (E.g., if the filesystem containing
              {option}`log_file` is 2 gibibytes in size, and {option}`space_left` is set to 25%, then the audit daemon sets {option}`space_left` to approximately 500 mebibytes.

              ::: {.note}
              This calculation is performed when the audit daemon starts, so if you resize the filesystem containing {option}`log_file` while the
              audit daemon is running, you should send the audit daemon SIGHUP to re-read the configuration file and recalculate the correct per‐
              centage.
              :::
            '';
          };
          admin_space_left = lib.mkOption {
            type = lib.types.either lib.types.int (lib.types.strMatching "[0-9]+%");
            default = 50;
            description = ''
              This is a numeric value in mebibytes (MiB) that tells the audit daemon when to perform a configurable action because the system is running
              low on disk space. This should be considered the last chance to do something before running out of disk space. The numeric value for
              this parameter should be lower than the number for {option}`space_left`. You may also append a percent sign (e.g. 1%) to the number to have
              the audit daemon calculate the number based on the disk partition size.
            '';
          };
        };
      };

      default = { };
      description = "auditd configuration file contents. See {auditd.conf} for supported values.";
    };

    plugins = lib.mkOption {
      type = lib.types.attrsOf pluginOptions;
      default = { };
      defaultText = lib.literalExpression ''
        {
          af_unix = {
            path = lib.getExe' pkgs.audit "audisp-af_unix";
            args = [
              "0640"
              "/var/run/audispd_events"
              "string"
            ];
            format = "binary";
          };
          remote = {
            path = lib.getExe' pkgs.audit "audisp-remote";
            settings = { };
          };
          filter = {
            path = lib.getExe' pkgs.audit "audisp-filter";
            args = [
              "allowlist"
              "/etc/audit/audisp-filter.conf"
              (lib.getExe' pkgs.audit "audisp-syslog")
              "LOG_USER"
              "LOG_INFO"
              "interpret"
            ];
            settings = { };
          };
          syslog = {
            path = lib.getExe' pkgs.audit "audisp-syslog";
            args = [ "LOG_INFO" ];
          };
        }
      '';
      description = "Plugin definitions to register with auditd";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          let
            cfg' = cfg.settings;
          in
          (
            (lib.isInt cfg'.space_left && lib.isInt cfg'.admin_space_left)
            -> cfg'.space_left > cfg'.admin_space_left
          )
          && (
            let
              get_percent = s: lib.toInt (lib.strings.removeSuffix "%" s);
            in
            (lib.isString cfg'.space_left && lib.isString cfg'.admin_space_left)
            -> (get_percent cfg'.space_left) > (get_percent cfg'.admin_space_left)
          );
        message = "`security.auditd.settings.space_left` must be larger than `security.auditd.settings.admin_space_left`";
      }
    ];

    # Starting the userspace daemon should also enable audit in the kernel
    security.audit.enable = lib.mkDefault true;

    # setting this to anything other than /etc/audit/plugins.d will break, so we pin it here
    security.auditd.settings.plugin_dir = "/etc/audit/plugins.d";

    environment.etc = {
      "audit/auditd.conf".text = prepareConfigText cfg.settings;
    }
    // (lib.mapAttrs' (
      pluginName: pluginDefinitionConfigValue:
      lib.nameValuePair "audit/plugins.d/${pluginName}.conf" {
        text = prepareConfigText (lib.removeAttrs pluginDefinitionConfigValue [ "settings" ]);
      }
    ) cfg.plugins)
    // (lib.mapAttrs' (
      pluginName: pluginDefinitionConfigValue:
      lib.nameValuePair "audit/audisp-${pluginName}.conf" {
        text = prepareConfigText pluginDefinitionConfigValue.settings;
      }
    ) (lib.filterAttrs (_: v: v.settings != null) cfg.plugins));

    security.auditd.plugins = {
      af_unix = {
        path = lib.getExe' pkgs.audit "audisp-af_unix";
        args = [
          "0640"
          "/var/run/audispd_events"
          "string"
        ];
        format = "binary";
      };
      remote = {
        path = lib.getExe' pkgs.audit "audisp-remote";
        settings = { };
      };
      filter = {
        path = lib.getExe' pkgs.audit "audisp-filter";
        args = [
          "allowlist"
          "/etc/audit/audisp-filter.conf"
          (lib.getExe' pkgs.audit "audisp-syslog")
          "LOG_USER"
          "LOG_INFO"
          "interpret"
        ];
        settings = { };
      };
      syslog = {
        path = lib.getExe' pkgs.audit "audisp-syslog";
        args = [ "LOG_INFO" ];
      };
    };

    systemd.services.auditd = {
      description = "Security Audit Logging Service";
      documentation = [ "man:auditd(8)" ];
      wantedBy = [ "sysinit.target" ];
      after = [
        "local-fs.target"
        "systemd-tmpfiles-setup.service"
      ];
      before = [
        "sysinit.target"
        "shutdown.target"
      ];
      conflicts = [ "shutdown.target" ];

      unitConfig = {
        DefaultDependencies = false;
        RefuseManualStop = true;
        ConditionVirtualization = "!container";
        ConditionKernelCommandLine = [
          "!audit=0"
          "!audit=off"
        ];
      };

      serviceConfig = {
        LogsDirectory = "audit";
        ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
        Restart = "on-failure";
        # Do not restart for intentional exits. See EXIT CODES section in auditd(8).
        RestartPreventExitStatus = "2 4 6";

        # Upstream hardening settings
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RestrictRealtime = true;
      };
    };
  };
}
