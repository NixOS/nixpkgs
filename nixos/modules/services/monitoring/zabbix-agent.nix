{ config, lib, pkgs, ... }:

let
  cfg = config.services.zabbixAgent;

  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption;
  inherit (lib) attrValues concatMapStringsSep literalExample optionalString types;
  inherit (lib.generators) toKeyValue;

  user = "zabbix-agent";
  group = "zabbix-agent";

  moduleEnv = pkgs.symlinkJoin {
    name = "zabbix-agent-module-env";
    paths = attrValues cfg.modules;
  };

  configFile = pkgs.writeText "zabbix_agent.conf" (toKeyValue { listsAsDuplicateKeys = true; } cfg.settings);

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "zabbixAgent" "extraConfig" ] "Use services.zabbixAgent.settings instead.")
  ];

  # interface

  options = {

    services.zabbixAgent = {
      enable = mkEnableOption "the Zabbix Agent";

      package = mkOption {
        type = types.package;
        default = pkgs.zabbix.agent;
        defaultText = "pkgs.zabbix.agent";
        description = "The Zabbix package to use.";
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [ nettools ];
        defaultText = "[ nettools ]";
        example = "[ nettools mysql ]";
        description = ''
          Packages to be added to the Zabbix <envar>PATH</envar>.
          Typically used to add executables for scripts, but can be anything.
        '';
      };

      modules = mkOption {
        type = types.attrsOf types.package;
        description = "A set of modules to load.";
        default = {};
        example = literalExample ''
          {
            "dummy.so" = pkgs.stdenv.mkDerivation {
              name = "zabbix-dummy-module-''${cfg.package.version}";
              src = cfg.package.src;
              buildInputs = [ cfg.package ];
              sourceRoot = "zabbix-''${cfg.package.version}/src/modules/dummy";
              installPhase = '''
                mkdir -p $out/lib
                cp dummy.so $out/lib/
              ''';
            };
          }
        '';
      };

      server = mkOption {
        type = types.str;
        description = ''
          The IP address or hostname of the Zabbix server to connect to.
        '';
      };

      listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = ''
            List of comma delimited IP addresses that the agent should listen on.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 10050;
          description = ''
            Agent will listen on this port for connections from the server.
          '';
        };
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Zabbix Agent.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ int str (listOf str) ]);
        default = {};
        description = ''
          Zabbix Agent configuration. Refer to
          <link xlink:href="https://www.zabbix.com/documentation/current/manual/appendix/config/zabbix_agentd"/>
          for details on supported values.
        '';
        example = {
          Hostname = "example.org";
          DebugLevel = 4;
        };
      };

    };

  };

  # implementation

  config = mkIf cfg.enable {

    services.zabbixAgent.settings = mkMerge [
      {
        LogType = "console";
        Server = cfg.server;
        ListenIP = cfg.listen.ip;
        ListenPort = cfg.listen.port;
        LoadModule = builtins.attrNames cfg.modules;
      }
      (mkIf (cfg.modules != {}) { LoadModulePath = "${moduleEnv}/lib"; })
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    users.users.${user} = {
      description = "Zabbix Agent daemon user";
      inherit group;
      isSystemUser = true;
    };

    users.groups.${group} = { };

    systemd.services.zabbix-agent = {
      description = "Zabbix Agent";

      wantedBy = [ "multi-user.target" ];

      path = [ "/run/wrappers" ] ++ cfg.extraPackages;

      serviceConfig = {
        ExecStart = "@${cfg.package}/sbin/zabbix_agentd zabbix_agentd -f --config ${configFile}";
        Restart = "always";
        RestartSec = 2;

        User = user;
        Group = group;
        PrivateTmp = true;
      };
    };

  };

}
