{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.quagga;

  services = [ "babel" "bgp" "isis" "ospf6" "ospf" "pim" "rip" "ripng" ];
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
          ! Quagga ${daemonName service} configuration
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
      enable = mkEnableOption "the Quagga ${toUpper service} routing protocol";

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/quagga/${daemonName service}.conf";
        description = ''
          Configuration file to use for Quagga ${daemonName service}.
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

  options.services.quagga =
    {

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

    } // (genAttrs services serviceOptions);

  ###### implementation

  config = mkIf (any isEnabled allServices) {

    environment.systemPackages = [
      pkgs.quagga               # for the vtysh tool
    ];

    users.users.quagga = {
      description = "Quagga daemon user";
      isSystemUser = true;
      group = "quagga";
    };

    users.groups = {
      quagga = {};
      # Members of the quaggavty group can use vtysh to inspect the Quagga daemons
      quaggavty = {};
    };

    systemd.services =
      let
        quaggaService = service:
          let
            scfg = cfg.${service};
            daemon = daemonName service;
          in
            nameValuePair daemon ({
              wantedBy = [ "multi-user.target" ];
              restartTriggers = [ (configFile service) ];

              serviceConfig = {
                Type = "forking";
                PIDFile = "/run/quagga/${daemon}.pid";
                ExecStart = "@${pkgs.quagga}/libexec/quagga/${daemon} ${daemon} -d -f ${configFile service}"
                  + optionalString (scfg.vtyListenAddress != "") " -A ${scfg.vtyListenAddress}"
                  + optionalString (scfg.vtyListenPort != null) " -P ${toString scfg.vtyListenPort}";
                ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
                Restart = "on-abort";
              };
            } // (
              if service == "zebra" then
                {
                  description = "Quagga Zebra routing manager";
                  unitConfig.Documentation = "man:zebra(8)";
                  after = [ "network.target" ];
                  preStart = ''
                    install -m 0755 -o quagga -g quagga -d /run/quagga

                    ${pkgs.iproute}/bin/ip route flush proto zebra
                  '';
                }
              else
                {
                  description = "Quagga ${toUpper service} routing daemon";
                  unitConfig.Documentation = "man:${daemon}(8) man:zebra(8)";
                  bindsTo = [ "zebra.service" ];
                  after = [ "network.target" "zebra.service" ];
                }
            ));
       in
         listToAttrs (map quaggaService (filter isEnabled allServices));

  };

  meta.maintainers = with lib.maintainers; [ tavyc ];

}
