{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.falco;
  settingsFormat = pkgs.formats.yaml { };

  stockRules = "${cfg.package}/etc/falco/falco_rules.yaml";

  customRules = lib.mapAttrsToList (
    name: rules: settingsFormat.generate "${name}.yaml" rules
  ) cfg.rules;

  # Only store paths can be checked at build time; a runtime directory in
  # `rules_files` is left to Falco.
  checkedRules = lib.filter (lib.hasPrefix builtins.storeDir) cfg.settings.rules_files;

  # A rule that does not compile fails the build instead of the service.
  configFile =
    pkgs.runCommand "falco.yaml"
      {
        nativeBuildInputs = [ cfg.package ];
        config = settingsFormat.generate "falco.yaml" cfg.settings;
      }
      ''
        falco -c $config ${lib.concatMapStringsSep " " (rules: "-V ${rules}") checkedRules}
        cp $config $out
      '';
in
{
  options.services.falco = {
    enable = lib.mkEnableOption "Falco, a runtime security tool that detects unexpected behavior from kernel events";

    package = lib.mkPackageOption pkgs "falco" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          json_output = true;
          priority = "warning";
          file_output = {
            enabled = true;
            filename = "/var/log/falco/events.json";
          };
        }
      '';
      description = ''
        Contents of `falco.yaml`. See the
        [configuration reference](https://falco.org/docs/reference/daemon/config-options/)
        for all keys.

        Only what is set here is written, not the example file shipped with
        Falco, so a key you leave out takes Falco's built-in default. The module
        sets `rules_files`, `load_plugins` and `plugins` so that the stock rules
        and the `container` plugin are loaded. Lists you add to these are
        appended to them; use `lib.mkForce` to replace them.

        Output goes to the journal by default. `syslog_output` and the
        `webserver` are disabled, since the former would log every alert twice
        and the latter listens on all interfaces upstream.
      '';
    };

    rules = lib.mkOption {
      type = lib.types.attrsOf settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          "50-local" = [
            {
              rule = "Write below /etc by a build";
              desc = "A build modified /etc";
              condition = "evt.type in (open, openat, openat2) and evt.is_open_write=true and fd.name startswith /etc/ and proc.name = nix-daemon";
              output = "Build wrote to /etc (file=%fd.name proc=%proc.name)";
              priority = "WARNING";
            }
          ];
        }
      '';
      description = ''
        Rule files, each given as the YAML list of rules, macros and lists that
        Falco reads. The attribute name becomes the file name.

        Files are loaded after the stock rules, in the lexical order of their
        names. Overrides of a stock rule or macro (`override` or `append`) must
        therefore come from here, not from the stock file itself. Prefix the
        names with a number to control the order.

        See the [rules reference](https://falco.org/docs/concepts/rules/) for
        the format.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          !(lib.elem cfg.settings.engine.kind [
            "kmod"
            "ebpf"
          ]);
        message = ''
          services.falco only supports the modern eBPF probe, which is built
          into the package: `settings.engine.kind` cannot be "${cfg.settings.engine.kind}".
        '';
      }
    ];

    services.falco.settings = {
      rules_files = [ stockRules ] ++ customRules;
      load_plugins = [ "container" ];
      plugins = [
        {
          name = "container";
          library_path = "${cfg.package}/share/falco/plugins/libcontainer.so";
          init_config = {
            label_max_len = 100;
            with_size = false;
          };
        }
      ];

      engine.kind = lib.mkDefault "modern_ebpf";

      # Reloading is the unit's job, on a changed configuration.
      watch_config_files = lib.mkDefault false;

      # Alerts and logs go to the journal, so syslog would only repeat them.
      stdout_output.enabled = lib.mkDefault true;
      log_stderr = lib.mkDefault true;
      syslog_output.enabled = lib.mkDefault false;
      log_syslog = lib.mkDefault false;

      webserver = {
        enabled = lib.mkDefault false;
        listen_address = lib.mkDefault "127.0.0.1";
      };

      # Falco refuses to start with metrics enabled and no interval.
      metrics.interval = lib.mkDefault "1h";
    };

    environment.etc."falco/falco.yaml".source = configFile;
    environment.systemPackages = [ cfg.package ];

    systemd.services.falco = {
      description = "Falco runtime security";
      documentation = [ "https://falco.org/docs/" ];
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ configFile ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -c /etc/falco/falco.yaml";
        # Falco re-reads its configuration and rules on SIGHUP.
        ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
        Restart = "on-failure";
        LogsDirectory = "falco";

        # The least privileged set for the modern eBPF probe, see
        # https://falco.org/docs/setup/container/#docker-least-privileged
        CapabilityBoundingSet = [
          "CAP_BPF"
          "CAP_PERFMON"
          "CAP_SYS_PTRACE"
          "CAP_SYS_RESOURCE"
        ];
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectKernelModules = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };
  };

  meta = {
    doc = ./falco.md;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
