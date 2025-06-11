{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.suricata;
  pkg = cfg.package;
  yaml = pkgs.formats.yaml { };
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    literalExpression
    filterAttrsRecursive
    concatStringsSep
    strings
    lists
    mkIf
    ;
in
{
  meta.maintainers = with lib.maintainers; [ felbinger ];

  options.services.suricata = {
    enable = mkEnableOption "Suricata";

    package = mkPackageOption pkgs "suricata" { };

    configFile = mkOption {
      type = types.path;
      visible = false;
      default = pkgs.writeTextFile {
        name = "suricata.yaml";
        text = ''
          %YAML 1.1
          ---
          ${builtins.readFile (
            yaml.generate "suricata-settings-raw.yaml" (
              filterAttrsRecursive (name: value: value != null) cfg.settings
            )
          )}
        '';
      };
      description = ''
        Configuration file for suricata.

        It is not usual to override the default values; it is recommended to use `settings`.
        If you want to include extra configuration to the file, use the `settings.includes`.
      '';
    };

    settings = mkOption {
      type = types.submodule (import ./settings.nix { inherit config lib yaml; });
      example = literalExpression ''
        vars.address-groups.HOME_NET = "192.168.178.0/24";
        outputs = [
          {
            fast = {
              enabled = true;
              filename = "fast.log";
              append = "yes";
            };
          }
          {
            eve-log = {
              enabled = true;
              filetype = "regular";
              filename = "eve.json";
              community-id = true;
              types = [
                {
                  alert.tagged-packets = "yes";
                }
              ];
            };
          }
        ];
        af-packet = [
          {
            interface = "eth0";
            cluster-id = "99";
            cluster-type = "cluster_flow";
            defrag = "yes";
          }
          {
            interface = "default";
          }
        ];
        af-xdp = [
          {
            interface = "eth1";
          }
        ];
        dpdk.interfaces = [
          {
            interface = "eth2";
          }
        ];
        pcap = [
          {
            interface = "eth3";
          }
        ];
        app-layer.protocols = {
          telnet.enabled = "yes";
          dnp3.enabled = "yes";
          modbus.enabled = "yes";
        };
      '';
      description = "Suricata settings";
    };

    enabledSources = mkOption {
      type = types.listOf types.str;
      # see: nix-shell -p suricata python3Packages.pyyaml --command 'suricata-update list-sources'
      default = [
        "et/open"
        "etnetera/aggressive"
        "stamus/lateral"
        "oisf/trafficid"
        "tgreen/hunting"
        "sslbl/ja3-fingerprints"
        "sslbl/ssl-fp-blacklist"
        "malsilo/win-malware"
        "pawpatrules"
      ];
      description = ''
        List of sources that should be enabled.
        Currently sources which require a secret-code are not supported.
      '';
    };

    disabledRules = mkOption {
      type = types.listOf types.str;
      # protocol dnp3 seams to be disabled, which causes the signature evaluation to fail, so we disable the
      # dnp3 rules, see https://github.com/OISF/suricata/blob/master/rules/dnp3-events.rules for more details
      default = [
        "2270000"
        "2270001"
        "2270002"
        "2270003"
        "2270004"
      ];
      description = ''
        List of rules that should be disabled.
      '';
    };
  };

  config =
    let
      captureInterfaces =
        let
          inherit (lists) unique optionals;
        in
        unique (
          map (e: e.interface) (
            (optionals (cfg.settings.af-packet != null) cfg.settings.af-packet)
            ++ (optionals (cfg.settings.af-xdp != null) cfg.settings.af-xdp)
            ++ (optionals (
              cfg.settings.dpdk != null && cfg.settings.dpdk.interfaces != null
            ) cfg.settings.dpdk.interfaces)
            ++ (optionals (cfg.settings.pcap != null) cfg.settings.pcap)
          )
        );
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = (builtins.length captureInterfaces) > 0;
          message = ''
            At least one capture interface must be configured:
            - `services.suricata.settings.af-packet`
            - `services.suricata.settings.af-xdp`
            - `services.suricata.settings.dpdk.interfaces`
            - `services.suricata.settings.pcap`
          '';
        }
      ];

      boot.kernelModules = mkIf (cfg.settings.af-packet != null) [ "af_packet" ];

      users = {
        groups.${cfg.settings.run-as.group} = { };
        users.${cfg.settings.run-as.user} = {
          group = cfg.settings.run-as.group;
          isSystemUser = true;
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.settings."default-log-dir"} 755 ${cfg.settings.run-as.user} ${cfg.settings.run-as.group}"
        "d /var/lib/suricata 755 ${cfg.settings.run-as.user} ${cfg.settings.run-as.group}"
        "d ${cfg.settings."default-rule-path"} 755 ${cfg.settings.run-as.user} ${cfg.settings.run-as.group}"
      ];

      systemd.services = {
        suricata-update = {
          description = "Update Suricata Rules";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];

          script =
            let
              python = pkgs.python3.withPackages (ps: with ps; [ pyyaml ]);
              enabledSourcesCmds = map (
                src: "${python.interpreter} ${pkg}/bin/suricata-update enable-source ${src}"
              ) cfg.enabledSources;
            in
            ''
              ${concatStringsSep "\n" enabledSourcesCmds}
              ${python.interpreter} ${pkg}/bin/suricata-update update-sources
              ${python.interpreter} ${pkg}/bin/suricata-update update --suricata-conf ${cfg.configFile} --no-test \
                --disable-conf ${pkgs.writeText "suricata-disable-conf" "${concatStringsSep "\n" cfg.disabledRules}"}
            '';
          serviceConfig = {
            Type = "oneshot";

            PrivateTmp = true;
            PrivateDevices = true;
            PrivateIPC = true;

            DynamicUser = true;
            User = cfg.settings.run-as.user;
            Group = cfg.settings.run-as.group;

            ReadOnlyPaths = cfg.configFile;
            ReadWritePaths = [
              "/var/lib/suricata"
              cfg.settings."default-rule-path"
            ];
          };
        };
        suricata = {
          description = "Suricata";
          wantedBy = [ "multi-user.target" ];
          after = [ "suricata-update.service" ];
          serviceConfig =
            let
              interfaceOptions = strings.concatMapStrings (interface: " -i ${interface}") captureInterfaces;
            in
            {
              ExecStartPre = "!${pkg}/bin/suricata -c ${cfg.configFile} -T";
              ExecStart = "!${pkg}/bin/suricata -c ${cfg.configFile}${interfaceOptions}";
              Restart = "on-failure";

              User = cfg.settings.run-as.user;
              Group = cfg.settings.run-as.group;

              NoNewPrivileges = true;
              PrivateTmp = true;
              PrivateDevices = true;
              PrivateIPC = true;
              ProtectSystem = "strict";
              DevicePolicy = "closed";
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              ProtectHostname = true;
              ProtectProc = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              ProtectControlGroups = true;
              ProcSubset = "pid";
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              RemoveIPC = true;

              ReadOnlyPaths = cfg.configFile;
              ReadWritePaths = cfg.settings."default-log-dir";
              RuntimeDirectory = "suricata";
            };
        };
      };
    };
}
