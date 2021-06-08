{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.frr;

  services = [
    "static"
    "bgp"
    "ospf"
    "ospf6"
    "rip"
    "ripng"
    "isis"
    "pim"
    "ldp"
    "nhrp"
    "eigrp"
    "babel"
    "sharp"
    "pbr"
    "bfd"
    "fabric"
  ];

  allServices = services ++ [ "zebra" ];

  isEnabled = service: cfg.${service}.enable;

  daemonName = service: if service == "zebra" then service else "${service}d";

  configFile = service:
    let
      scfg = cfg.${service};
    in
      if scfg.configFile != null then scfg.configFile
      else pkgs.writeText "${daemonName service}.conf"
        ''
          ! FRR ${daemonName service} configuration
          !
          hostname ${config.networking.hostName}
          log syslog
          service password-encryption
          !
          ${scfg.config}
          !
          end
        '';

  serviceOptions = service:
    {
      enable = mkEnableOption "the FRR ${toUpper service} routing protocol";

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/frr/${daemonName service}.conf";
        description = ''
          Configuration file to use for FRR ${daemonName service}.
          By default the NixOS generated files are used.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        example =
          let
            examples = {
              rip = ''
                router rip
                  network 10.0.0.0/8
              '';

              ospf = ''
                router ospf
                  network 10.0.0.0/8 area 0
              '';

              bgp = ''
                router bgp 65001
                  neighbor 10.0.0.1 remote-as 65001
              '';
            };
          in
            examples.${service} or "";
        description = ''
          ${daemonName service} configuration statements.
        '';
      };

      vtyListenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Address to bind to for the VTY interface.
        '';
      };

      vtyListenPort = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          TCP Port to bind to for the VTY interface.
        '';
      };
    };

in

{

  ###### interface
  imports = [
    {
      options.services.frr = {
        zebra = (serviceOptions "zebra") // {
          enable = mkOption {
            type = types.bool;
            default = any isEnabled services;
            description = ''
              Whether to enable the Zebra routing manager.

              The Zebra routing manager is automatically enabled
              if any routing protocols are configured.
            '';
          };
        };
      };
    }
    { options.services.frr = (genAttrs services serviceOptions); }
  ];

  ###### implementation

  config = mkIf (any isEnabled allServices) {

    environment.systemPackages = [
      pkgs.frr # for the vtysh tool
    ];

    users.users.frr = {
      description = "FRR daemon user";
      isSystemUser = true;
      group = "frr";
    };

    users.groups = {
      frr = {};
      # Members of the frrvty group can use vtysh to inspect the FRR daemons
      frrvty = { members = [ "frr" ]; };
    };

    systemd.services =
      let
        frrService = service:
          let
            scfg = cfg.${service};
            daemon = daemonName service;
          in
            nameValuePair daemon ({
              wantedBy = [ "multi-user.target" ];
              after = [ "network-pre.target" "systemd-sysctl.service" ];
              wants = [ "network.target" ];

              serviceConfig = {
                Type = "forking";
                PIDFile = "/run/frr/${daemon}.pid";
                ExecStart = "@${pkgs.frr}/libexec/frr/${daemon} ${daemon} -d -f ${configFile service}"
                  + optionalString (scfg.vtyListenAddress != "") " -A ${scfg.vtyListenAddress}"
                  + optionalString (scfg.vtyListenPort != null) " -P ${toString scfg.vtyListenPort}";
                ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
                Restart = "on-abnormal";
              };
            } // (
              if service == "zebra" then
                {
                  description = "FRR Zebra routing manager";
                  unitConfig.Documentation = "man:zebra(8)";
                  preStart = ''
                    install -m 0755 -o frr -g frr -d /run/frr
                  '';
                }
              else
                {
                  description = "FRR ${toUpper service} routing daemon";
                  unitConfig.Documentation = "man:${daemon}(8) man:zebra(8)";
                  bindsTo = [ "zebra.service" ];
                  after = [ "zebra.service" ];
                }
            ));
       in
         listToAttrs (map frrService (filter isEnabled allServices));

  };

  meta.maintainers = with lib.maintainers; [ woffs ];

}
