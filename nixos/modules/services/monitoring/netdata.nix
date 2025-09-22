{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.netdata;

  wrappedPlugins = pkgs.runCommand "wrapped-plugins" { preferLocalBuild = true; } ''
    mkdir -p $out/libexec/netdata/plugins.d
    ln -s /run/wrappers/bin/apps.plugin $out/libexec/netdata/plugins.d/apps.plugin
    ln -s /run/wrappers/bin/cgroup-network $out/libexec/netdata/plugins.d/cgroup-network
    ln -s /run/wrappers/bin/perf.plugin $out/libexec/netdata/plugins.d/perf.plugin
    ln -s /run/wrappers/bin/slabinfo.plugin $out/libexec/netdata/plugins.d/slabinfo.plugin
    ln -s /run/wrappers/bin/freeipmi.plugin $out/libexec/netdata/plugins.d/freeipmi.plugin
    ln -s /run/wrappers/bin/systemd-journal.plugin $out/libexec/netdata/plugins.d/systemd-journal.plugin
    ln -s /run/wrappers/bin/logs-management.plugin $out/libexec/netdata/plugins.d/logs-management.plugin
    ln -s /run/wrappers/bin/network-viewer.plugin $out/libexec/netdata/plugins.d/network-viewer.plugin
    ln -s /run/wrappers/bin/debugfs.plugin $out/libexec/netdata/plugins.d/debugfs.plugin
  '';

  plugins = [
    "${cfg.package}/libexec/netdata/plugins.d"
    "${wrappedPlugins}/libexec/netdata/plugins.d"
  ]
  ++ cfg.extraPluginPaths;

  configDirectory = pkgs.runCommand "netdata-config-d" { } ''
    mkdir $out
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (path: file: ''
        mkdir -p "$out/$(dirname ${path})"
        ${if path == "apps_groups.conf" then "cp" else "ln -s"} "${file}" "$out/${path}"
      '') cfg.configDir
    )}
  '';

  localConfig = {
    global = {
      "config directory" = "/etc/netdata/conf.d";
      "plugins directory" = lib.concatStringsSep " " plugins;
    };
    web = {
      "web files owner" = "root";
      "web files group" = "root";
    };
    "plugin:cgroups" = {
      "script to get cgroup network interfaces" =
        "${wrappedPlugins}/libexec/netdata/plugins.d/cgroup-network";
      "use unified cgroups" = "yes";
    };
  };
  mkConfig = lib.generators.toINI { } (lib.recursiveUpdate localConfig cfg.config);
  configFile = pkgs.writeText "netdata.conf" (
    if cfg.configText != null then cfg.configText else mkConfig
  );

  defaultUser = "netdata";

  isThereAnyWireGuardTunnels =
    config.networking.wireguard.enable
    || lib.any (
      c: lib.hasAttrByPath [ "netdevConfig" "Kind" ] c && c.netdevConfig.Kind == "wireguard"
    ) (builtins.attrValues config.systemd.network.netdevs);

  extraNdsudoPathsEnv = pkgs.buildEnv {
    name = "netdata-ndsudo-env";
    paths = cfg.extraNdsudoPackages;
    pathsToLink = [ "/bin" ];
  };

in
{
  options = {
    services.netdata = {
      enable = lib.mkEnableOption "netdata";

      package = lib.mkPackageOption pkgs "netdata" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "netdata";
        description = "User account under which netdata runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "netdata";
        description = "Group under which netdata runs.";
      };

      configText = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        description = "Verbatim netdata.conf, cannot be combined with config.";
        default = null;
        example = ''
          [global]
          debug log = syslog
          access log = syslog
          error log = syslog
        '';
      };

      python = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to enable python-based plugins
          '';
        };
        recommendedPythonPackages = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable a set of recommended Python plugins
            by installing extra Python packages.
          '';
        };
        extraPackages = lib.mkOption {
          type = lib.types.functionTo (lib.types.listOf lib.types.package);
          default = ps: [ ];
          defaultText = lib.literalExpression "ps: []";
          example = lib.literalExpression ''
            ps: [
              ps.psycopg2
              ps.docker
              ps.dnspython
            ]
          '';
          description = ''
            Extra python packages available at runtime
            to enable additional python plugins.
          '';
        };
      };

      extraPluginPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = lib.literalExpression ''
          [ "/path/to/plugins.d" ]
        '';
        description = ''
          Extra paths to add to the netdata global "plugins directory"
          option.  Useful for when you want to include your own
          collection scripts.

          Details about writing a custom netdata plugin are available at:
          <https://docs.netdata.cloud/collectors/plugins.d/>

          Cannot be combined with configText.
        '';
      };

      extraNdsudoPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Extra packages to add to `PATH` to make available to `ndsudo`.
          ::: {.warning}
          `ndsudo` has SUID privileges, be careful what packages you list here.
          :::

          ::: {.note}
          `cfg.package` must be built with `withNdsudo = true`
          :::
        '';
        example = ''
          [
            pkgs.smartmontools
            pkgs.nvme-cli
          ]
        '';
      };

      config = lib.mkOption {
        type = lib.types.attrsOf lib.types.attrs;
        default = { };
        description = "netdata.conf configuration as nix attributes. cannot be combined with configText.";
        example = lib.literalExpression ''
          global = {
            "debug log" = "syslog";
            "access log" = "syslog";
            "error log" = "syslog";
          };
        '';
      };

      configDir = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = ''
          Complete netdata config directory except netdata.conf.
          The default configuration is merged with changes
          defined in this option.
          Each top-level attribute denotes a path in the configuration
          directory as in environment.etc.
          Its value is the absolute path and must be readable by netdata.
          Cannot be combined with configText.
        '';
        example = lib.literalExpression ''
          "health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" '''
            sendmail="/path/to/sendmail"
          ''';
          "health.d" = "/run/secrets/netdata/health.d";
        '';
      };

      claimTokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          If set, automatically registers the agent using the given claim token
          file.
        '';
      };

      enableAnalyticsReporting = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable reporting of anonymous usage statistics to Netdata Inc. via either
          Google Analytics (in versions prior to 1.29.4), or Netdata Inc.'s
          self-hosted PostHog (in versions 1.29.4 and later).
          See: <https://learn.netdata.cloud/docs/agent/anonymous-statistics>
        '';
      };

      deadlineBeforeStopSec = lib.mkOption {
        type = lib.types.int;
        default = 120;
        description = ''
          In order to detect when netdata is misbehaving, we run a concurrent task pinging netdata (wait-for-netdata-up)
          in the systemd unit.

          If after a while, this task does not succeed, we stop the unit and mark it as failed.

          You can control this deadline in seconds with this option, it's useful to bump it
          if you have (1) a lot of data (2) doing upgrades (3) have low IOPS/throughput.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.config != { } -> cfg.configText == null;
        message = "Cannot specify both config and configText";
      }
    ];

    # Includes a set of recommended Python plugins in exchange of imperfect disk consumption.
    services.netdata.python.extraPackages = lib.mkIf cfg.python.recommendedPythonPackages (ps: [
      ps.requests
      ps.pandas
      ps.numpy
      ps.psycopg2
      ps.python-ldap
      ps.netdata-pandas
    ]);

    services.netdata.configDir.".opt-out-from-anonymous-statistics" = lib.mkIf (
      !cfg.enableAnalyticsReporting
    ) (pkgs.writeText ".opt-out-from-anonymous-statistics" "");
    environment.etc."netdata/netdata.conf".source = configFile;
    environment.etc."netdata/conf.d".source = configDirectory;

    systemd.tmpfiles.settings = lib.mkIf cfg.package.withNdsudo {
      "95-netdata-ndsudo" = {
        "/var/lib/netdata/ndsudo" = {
          "d" = {
            mode = "0550";
            user = cfg.user;
            group = cfg.group;
          };
        };

        "/var/lib/netdata/ndsudo/ndsudo" = {
          "L+" = {
            argument = "/run/wrappers/bin/ndsudo";
          };
        };

        "/var/lib/netdata/ndsudo/runtime-dependencies" = {
          "L+" = {
            argument = "${extraNdsudoPathsEnv}/bin";
          };
        };
      };
    };

    systemd.services.netdata = {
      description = "Real time performance monitoring";
      after = [
        "network.target"
        "suid-sgid-wrappers.service"
      ];
      # No wrapper means no "useful" netdata.
      requires = [ "suid-sgid-wrappers.service" ];
      wantedBy = [ "multi-user.target" ];
      path =
        (with pkgs; [
          curl
          gawk
          iproute2
          which
          procps
          bash
          nvme-cli # for go.d
          iw # for charts.d
          apcupsd # for charts.d
          # TODO: firehol # for FireQoS -- this requires more NixOS module support.
          util-linux # provides logger command; required for syslog health alarms
        ])
        ++ lib.optional cfg.python.enable (pkgs.python3.withPackages cfg.python.extraPackages)
        ++ lib.optional config.virtualisation.libvirtd.enable config.virtualisation.libvirtd.package
        ++ lib.optional config.virtualisation.docker.enable config.virtualisation.docker.package
        ++ lib.optionals config.virtualisation.podman.enable [
          pkgs.jq
          config.virtualisation.podman.package
        ]
        ++ lib.optional config.boot.zfs.enabled config.boot.zfs.package;
      environment = {
        PYTHONPATH = "${cfg.package}/libexec/netdata/python.d/python_modules";
        NETDATA_PIPENAME = "/run/netdata/ipc";
      }
      // lib.optionalAttrs (!cfg.enableAnalyticsReporting) {
        DO_NOT_TRACK = "1";
      };
      restartTriggers = [
        config.environment.etc."netdata/netdata.conf".source
        config.environment.etc."netdata/conf.d".source
      ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/netdata -P /run/netdata/netdata.pid -D -c /etc/netdata/netdata.conf";
        ExecReload = "${pkgs.util-linux}/bin/kill -s HUP -s USR1 -s USR2 $MAINPID";
        ExecStartPost = pkgs.writeShellScript "wait-for-netdata-up" ''
          while [ "$(${cfg.package}/bin/netdatacli ping)" != pong ]; do sleep 0.5; done
        '';

        TimeoutStopSec = cfg.deadlineBeforeStopSec;
        Restart = "on-failure";
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Performance
        LimitNOFILE = "30000";
        # Runtime directory and mode
        RuntimeDirectory = "netdata";
        RuntimeDirectoryMode = "0750";
        # State directory and mode
        StateDirectory = "netdata";
        StateDirectoryMode = "0750";
        # Cache directory and mode
        CacheDirectory = "netdata";
        CacheDirectoryMode = "0750";
        # Logs directory and mode
        LogsDirectory = "netdata";
        LogsDirectoryMode = "0750";
        # Configuration directory and mode
        ConfigurationDirectory = "netdata";
        ConfigurationDirectoryMode = "0755";
        # AmbientCapabilities
        AmbientCapabilities = lib.optional isThereAnyWireGuardTunnels "CAP_NET_ADMIN";
        # Capabilities
        CapabilityBoundingSet = [
          "CAP_DAC_OVERRIDE" # is required for freeipmi and slabinfo plugins
          "CAP_DAC_READ_SEARCH" # is required for apps and systemd-journal plugin
          "CAP_NET_RAW" # is required for fping app
          "CAP_PERFMON" # is required for perf plugin
          "CAP_SETPCAP" # is required for apps, perf and slabinfo plugins
          "CAP_SETUID" # is required for cgroups and cgroups-network plugins
          "CAP_SYSLOG" # is required for systemd-journal plugin
          "CAP_SYS_ADMIN" # is required for perf plugin
          "CAP_SYS_CHROOT" # is required for cgroups plugin
          "CAP_SYS_PTRACE" # is required for apps plugin
          "CAP_SYS_RESOURCE" # is required for ebpf plugin
        ]
        ++ lib.optionals cfg.package.withIpmi [
          "CAP_FOWNER"
          "CAP_SYS_RAWIO"
        ]
        ++ lib.optional isThereAnyWireGuardTunnels "CAP_NET_ADMIN";
        # Sandboxing
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        ProtectControlGroups = true;
        PrivateMounts = true;
      }
      // (lib.optionalAttrs (cfg.claimTokenFile != null) {
        LoadCredential = [
          "netdata_claim_token:${cfg.claimTokenFile}"
        ];

        ExecStartPre = pkgs.writeShellScript "netdata-claim" ''
          set -euo pipefail

          if [[ -f /var/lib/netdata/cloud.d/claimed_id ]]; then
            # Already registered
            exit
          fi

          exec ${cfg.package}/bin/netdata-claim.sh \
            -token="$(< "$CREDENTIALS_DIRECTORY/netdata_claim_token")" \
            -url=https://app.netdata.cloud \
            -daemon-not-running
        '';
      });
    };

    security.wrappers = {
      "apps.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/apps.plugin.org";
        capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "debugfs.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/debugfs.plugin.org";
        capabilities = "cap_dac_read_search+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "cgroup-network" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/cgroup-network.org";
        capabilities = "cap_setuid+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "perf.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/perf.plugin.org";
        capabilities = "cap_sys_admin+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

      "slabinfo.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/slabinfo.plugin.org";
        capabilities = "cap_dac_override+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };

    }
    // lib.optionalAttrs (cfg.package.withIpmi) {
      "freeipmi.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/freeipmi.plugin.org";
        capabilities = "cap_dac_override,cap_fowner,cap_sys_rawio+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };
    }
    // lib.optionalAttrs (cfg.package.withNetworkViewer) {
      "network-viewer.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/network-viewer.plugin.org";
        capabilities = "cap_sys_admin,cap_dac_read_search,cap_sys_ptrace+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };
    }
    // lib.optionalAttrs (cfg.package.withNdsudo) {
      "ndsudo" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/ndsudo.org";
        setuid = true;
        owner = "root";
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };
    }
    // lib.optionalAttrs (cfg.package.withSystemdJournal) {
      "systemd-journal.plugin" = {
        source = "${cfg.package}/libexec/netdata/plugins.d/systemd-journal.plugin.org";
        capabilities = "cap_dac_read_search,cap_syslog+ep";
        owner = cfg.user;
        group = cfg.group;
        permissions = "u+rx,g+x,o-rwx";
      };
    };

    security.pam.loginLimits = [
      {
        domain = "netdata";
        type = "soft";
        item = "nofile";
        value = "10000";
      }
      {
        domain = "netdata";
        type = "hard";
        item = "nofile";
        value = "30000";
      }
    ];

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        group = defaultUser;
        isSystemUser = true;
        extraGroups =
          lib.optional config.virtualisation.docker.enable "docker"
          ++ lib.optional config.virtualisation.podman.enable "podman";
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

  };
}
