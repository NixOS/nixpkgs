{ config, lib, utils, pkgs, ... }:

with lib;

let
  cfg = config.services.snort3;

  makeNet = (l: if builtins.elem "any" l then "'any'" else
  "'[[ ${removeSuffix " " (concatStringsSep " " l)} ]]'");

  genericConfigDir = pkgs.runCommand "generic-snort3-config" { } ''
    mkdir $out
    cp ${cfg.package}/etc/snort/snort.lua $out/generic_snort.lua
     substituteInPlace $out/generic_snort.lua \
     --replace "HOME_NET" "--HOME_NET" \
     --replace "EXTERNAL_NET" "--EXTERNAL_NET" \
     --replace "include" "--include" \
     --replace "if " "--if " --replace "end" "--end"
  '';

  generatedConfigFile = pkgs.writeText "snort.lua" ''
    HOME_NET = ${makeNet cfg.homeNet}
    EXTERNAL_NET = ${makeNet cfg.externalNet}

    include '${cfg.package}/etc/snort/snort_defaults.lua'
    include '${cfg.package}/etc/snort/file_magic.lua'
    include '${genericConfigDir}/generic_snort.lua'

    RULE_PATH = '${cfg.dataDir}/rules'
    BUILTIN_RULE_PATH = '${cfg.dataDir}/builtin_rules'
    PLUGIN_RULE_PATH = '${cfg.dataDir}/dynamic_rules'
    WHITE_LIST_PATH = '${cfg.dataDir}/intel'
    BLACK_LIST_PATH = '${cfg.dataDir}/intel'
    APPID_PATH = '${cfg.dataDir}/appid'

    ${cfg.extraConfigText}
  '';

  conf = (
    if cfg.configFile == null
    then generatedConfigFile
    else cfg.configFile
  );
in
{
  options = {
    services.snort3 = {
      enable = mkEnableOption "Snort - Network intrusion prevention and detection system";

      package = mkOption {
        type = types.package;
        default = pkgs.snort3;
        defaultText = literalExpression "pkgs.snort3";
        description = "Package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "snort3";
        description = ''
          User under which the service shall run after initialization.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "snort3";
        description = ''
          Group under which the service shall run after initialization.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/snort3";
        description = ''
          Specify the data directory of Snort used for e.g. Snort Rules.
        '';
      };

      homeNet = mkOption {
        type = types.listOf types.str;
        default = [ "any" ];
        example = literalExpression ''
          [
            "10.0.0.0/8"
            "192.168.0.0/16"
            "172.16.0.0/12"
            "fc00::/7"
            "fe80::/10"
          ]
        '';
        description = ''
          Specify the network addresses you are protecting before <option>services.snort3.extraConfigText</option>.
        '';
      };

      externalNet = mkOption {
        type = types.listOf types.str;
        default = [ "any" ];
        example = literalExpression ''
          [
            "203.0.113.0/24"
            "2001:db8::/32"
          ]
        '';
        description = ''
          Specify external network addresses before <option>services.snort3.extraConfigText</option>.
          Leave as "any" in most situations.
        '';
      };

      extraConfigText = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          SSH_PORTS = ' 22 2210'
          ips =
          {
             enable_builtin_rules = true,
             include = RULE_PATH .. "/snort.rules",
             variables = default_variables
          }
          alert_json =
          {
            file = false,
            fields = 'seconds action class dir dst_addr dst_ap dst_port eth_dst eth_len \
            eth_src eth_type gid icmp_code icmp_id icmp_seq icmp_type iface ip_id ip_len msg mpls \
            pkt_gen pkt_len pkt_num priority proto rev rule service sid src_addr src_ap src_port \
            target tcp_ack tcp_flags tcp_len tcp_seq tcp_win tos ttl udp_len vlan timestamp'
          }
        '';
        description = ''
          Specify the configuration for the service when 'configFile' is not used. As long as this
          option is empty a default template/starter configuration is loaded. To make use of Snort
          fully it is advised to create and load your own configuration, adjusted to your needs.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Specify a configuration file that should be used. It replaces <option>services.snort3.extraConfigText</option>.
          To make use of Snort fully it is advised to create and load your own configuration, adjusted to your needs.
        '';
      };

      maxThreads = mkOption {
        type = types.int;
        default = 1;
        example = literalExpression "2";
        description = ''
          Specify the maximum number of packet processing threads. Set `0` to set maxThreads equal available CPU cores.
        '';
      };

      netInterfaces = mkOption {
        type = types.listOf types.str;
        default = [ "eth0" ];
        example = literalExpression ''
          [ "eth0" "eth1" ]
        '';
        description = ''
          Specify the network interfaces for Snort to use. Further examples: [ "eth0:eth1" ] (afpacket/inline),
          [ "42" ] (nfqueue/inline).
        '';
      };

      daqType = mkOption {
        type = types.enum [
          "afpacket"
          "bpf"
          "dump"
          "fst"
          "nfq"
          "pcap"
          "savefile"
          "trace"
        ];
        default = "afpacket";
        description = ''
          Specify the packet acquisition module type.
        '';
      };

      daqMode = mkOption {
        type = types.enum [
          "inline"
          "passive"
          "read-file"
        ];
        default = "passive";
        description = ''
          Specify the DAQ module operating mode.
        '';
      };

      daqVars = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''
          [
            "buffer_size_mb=512"
            "fanout_type=hash"
          ]
        '';
        description = ''
          Specify extra DAQ configuration variables.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''
          [
            "-s 65535"
            "-k none"
            "-M"
            "-A alert_json"
            "-U"
            "-y"
          ]
        '';
        description = ''
          Specify a list of additional command line flags.
        '';
      };

    };
  };

  config = mkIf config.services.snort3.enable {
    users.users."${cfg.user}" = {
      description = "Snort Service User";
      group = "${cfg.group}";
      isSystemUser = true;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups."${cfg.group}" = { };

    systemd.services.snort3 = {
      description = "Snort - Network intrusion prevention and detection system";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig =
        let
          cmd = "${cfg.package}/bin/snort";

          netInterfaces = lists.map (i: "-i " + i) cfg.netInterfaces;
          daqVariables = lists.map (v: "--daq-var " + v) cfg.daqVars;

          cmdArgs = builtins.replaceStrings [ "\"" ] [ "" ] (utils.escapeSystemdExecArgs (
            [
              "-c ${conf}"
            ]
            ++ optional (cfg.daqType != "nfq") "-u ${cfg.user}"
            ++ optional (cfg.daqType != "nfq") "-g ${cfg.group}"
            ++ cfg.extraFlags

            ++ netInterfaces
            ++ [
              "-z ${toString cfg.maxThreads}"

              "--daq ${cfg.daqType}"
              "--daq-mode ${cfg.daqMode}"
            ]
            ++ daqVariables
          ));
        in
        {
          Restart = "on-failure";
          TimeoutStartSec = "600";

          User = cfg.user;
          Group = cfg.group;

          WorkingDirectory = cfg.dataDir;

          ExecStartPre =
            let
              prepareScript = pkgs.writers.writeBash "snort-pre-start-prepare.sh" ''
                ${pkgs.coreutils}/bin/mkdir -p {rules,builtin_rules,dynamic_rules,appid,intel}
                ${pkgs.coreutils}/bin/touch rules/snort.rules
              '';
            in
            [
              prepareScript
              "+${cmd} ${cmdArgs} -T"
            ];

          ExecStart = "+${cmd} ${cmdArgs}";

          ExecReload = "+${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";

          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" "CAP_IPC_LOCK" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_RAW" "CAP_IPC_LOCK" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "full";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" "AF_UNIX" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = false;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "@network-io" "~@privileged" "~@resources" ];
          UMask = "0027";
        };
    };
  };
}
