nftables: lib: pkgs:

let
  inherit (lib)
    concatStrings
    foldl
    foldl'
    genAttrs
    literalExpression
    maintainers
    mapAttrs
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    types
    mkOptionDefault
    flip
    attrNames
    xor
    ;

  mkExporterOpts = (
    { name, port }:
    {
      enable = mkEnableOption "the prometheus ${name} exporter";
      port = mkOption {
        type = types.port;
        default = port;
        description = ''
          Port to listen on.
        '';
      };
      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Address to listen on.
        '';
      };
      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra commandline options to pass to the ${name} exporter.
        '';
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
      firewallFilter = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = literalExpression ''
          "-i eth0 -p tcp -m tcp --dport ${toString port}"
        '';
        description = ''
          Specify a filter for iptables to use when
          {option}`services.prometheus.exporters.${name}.openFirewall`
          is true. It is used as `ip46tables -I nixos-fw firewallFilter -j nixos-fw-accept`.
        '';
      };
      firewallRules = mkOption {
        type = types.nullOr types.lines;
        default = null;
        example = literalExpression ''
          iifname "eth0" tcp dport ${toString port} counter accept
        '';
        description = ''
          Specify rules for nftables to add to the input chain
          when {option}`services.prometheus.exporters.${name}.openFirewall` is true.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "${name}-exporter";
        description = ''
          User name under which the ${name} exporter shall be run.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "${name}-exporter";
        description = ''
          Group under which the ${name} exporter shall be run.
        '';
      };
    }
  );

  mkSubModule =
    {
      name,
      port,
      extraOpts,
      imports,
    }:
    {
      ${name} = mkOption {
        type = types.submodule [
          {
            inherit imports;
            options = (
              mkExporterOpts {
                inherit name port;
              }
              // extraOpts
            );
          }
          (
            { config, ... }:
            mkIf config.openFirewall {
              firewallFilter = mkDefault "-p tcp -m tcp --dport ${toString config.port}";
              firewallRules = mkDefault ''tcp dport ${toString config.port} accept comment "${name}-exporter"'';
            }
          )
        ];
        internal = true;
        default = { };
      };
    };

  mkExporterConf =
    {
      name,
      conf,
      serviceOpts,
    }:
    let
      enableDynamicUser = serviceOpts.serviceConfig.DynamicUser or true;
    in
    mkIf conf.enable {
      warnings = conf.warnings or [ ];
      assertions = conf.assertions or [ ];
      users.users."${name}-exporter" = (
        mkIf (conf.user == "${name}-exporter" && !enableDynamicUser) {
          description = "Prometheus ${name} exporter service user";
          isSystemUser = true;
          inherit (conf) group;
        }
      );
      users.groups = mkMerge [
        (mkIf (conf.group == "${name}-exporter" && !enableDynamicUser) {
          "${name}-exporter" = { };
        })
        (mkIf (name == "smartctl") {
          "smartctl-exporter-access" = { };
        })
      ];
      services.udev.extraRules = mkIf (name == "smartctl") ''
        ACTION=="add", SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", RUN+="${pkgs.acl}/bin/setfacl -m g:smartctl-exporter-access:rw /dev/$kernel"
      '';
      networking.firewall.extraCommands = mkIf (conf.openFirewall && !nftables) (concatStrings [
        "ip46tables -A nixos-fw ${conf.firewallFilter} "
        "-m comment --comment ${name}-exporter -j nixos-fw-accept"
      ]);
      networking.firewall.extraInputRules = mkIf (conf.openFirewall && nftables) conf.firewallRules;
      systemd.services."prometheus-${name}-exporter" = mkMerge ([
        {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig.Restart = mkDefault "always";
          serviceConfig.PrivateTmp = mkDefault true;
          serviceConfig.WorkingDirectory = mkDefault /tmp;
          serviceConfig.DynamicUser = mkDefault enableDynamicUser;
          serviceConfig.User = mkDefault conf.user;
          serviceConfig.Group = conf.group;
          # Hardening
          serviceConfig.CapabilityBoundingSet = mkDefault [ "" ];
          serviceConfig.DeviceAllow = [ "" ];
          serviceConfig.LockPersonality = true;
          serviceConfig.MemoryDenyWriteExecute = true;
          serviceConfig.NoNewPrivileges = true;
          serviceConfig.PrivateDevices = mkDefault true;
          serviceConfig.ProtectClock = mkDefault true;
          serviceConfig.ProtectControlGroups = true;
          serviceConfig.ProtectHome = true;
          serviceConfig.ProtectHostname = true;
          serviceConfig.ProtectKernelLogs = true;
          serviceConfig.ProtectKernelModules = true;
          serviceConfig.ProtectKernelTunables = true;
          serviceConfig.ProtectSystem = mkDefault "strict";
          serviceConfig.RemoveIPC = true;
          serviceConfig.RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          serviceConfig.RestrictNamespaces = true;
          serviceConfig.RestrictRealtime = true;
          serviceConfig.RestrictSUIDSGID = true;
          serviceConfig.SystemCallArchitectures = "native";
          serviceConfig.UMask = "0077";
        }
        serviceOpts
      ]);
    };

  mkDownstreamOptions =
    name: opts:
    mkSubModule {
      inherit name;
      inherit (opts) port;
      extraOpts = opts.extraOpts or { };
      imports = opts.imports or [ ];
    };

  mkDownstreamConfig =
    name: opts: cfg:
    mkExporterConf {
      inherit name;
      inherit (opts) serviceOpts;
      conf = cfg;
    };
in
{
  inherit
    mkExporterConf
    mkSubModule
    mkDownstreamOptions
    mkDownstreamConfig
    ;
}
