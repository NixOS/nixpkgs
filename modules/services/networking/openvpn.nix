{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.openvpn;

  inherit (pkgs) openvpn;

  PATH = "${pkgs.iptables}/sbin:${pkgs.coreutils}/bin:${pkgs.iproute}/sbin:${pkgs.nettools}/sbin";

  makeOpenVPNJob = cfg : name:
    let
      upScript = ''
        #!/bin/sh
        exec &> /var/log/openvpn-${name}-up
        PATH=${PATH}
        ${cfg.up}
      '';
      downScript = ''
        #!/bin/sh
        exec &> /var/log/openvpn-${name}-down
        PATH=${PATH}
        ${cfg.down}
      '';
      configFile = pkgs.writeText "openvpn-config-${name}"
        ''
          ${if cfg.up != "" || cfg.down != "" then "script-security 2" else ""}
          ${cfg.config}
          ${if cfg.up != "" then "up ${pkgs.writeScript "openvpn-${name}-up" upScript}" else "" }
          ${if cfg.down != "" then "down ${pkgs.writeScript "openvpn-${name}-down" downScript}" else "" }
        '';
    in {
      description = "OpenVPN-${name}";

      startOn = "network-interfaces/started";
      stopOn = "network-interfaces/stop";

      environment = { PATH = "${pkgs.coreutils}/bin"; };

      script =
        ''
          exec &> /var/log/openvpn-${name}
          ${config.system.sbin.modprobe} tun || true
          ${openvpn}/sbin/openvpn --config ${configFile}
        '';
    };

  openvpnInstanceOptions = {

    config = mkOption {
      type = types.string;
      description = ''
        config of this openvpn instance
      '';
    };
    up = mkOption {
      default = "";
      type = types.string;
      description = ''
        script which is run when server instance starts up succesfully.
        Use it to setup firewall and routing
      '';
    };
    down = mkOption {
      default = "";
      type = types.string;
      description = ''
        script which is run when server instance shuts down
        Usually this reverts what up has done
      '';
    };

  };

in
  
{

  ###### interface

  options = {
  
    services.openvpn = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable OpenVPN.";
      };


      servers = mkOption {

        default = {};

        example = {
            mostSimple = {
              config = ''
                # Most simple configuration: http://openvpn.net/index.php/documentation/miscellaneous/static-key-mini-howto.html.
                # server : 
                dev tun
                ifconfig 10.8.0.1 10.8.0.2
                secret static.key
              '';
              up = "ip route add ..!";
              down = "ip route add ..!";
            };
            clientMostSimple = {
              config = ''
                #client:
                #remote myremote.mydomain
                #dev tun
                #ifconfig 10.8.0.2 10.8.0.1
                #secret static.key
              '';
            };
            serverScalable = {
              config = ''
                multiple clienst
                see example file found in http://openvpn.net/index.php/documentation/howto.html
              '';
            };
        };

        # !!! clean up this description please
        description = ''
          You can define multiple openvpn instances.

          The id of an instance is given by the attribute name.

          Each instance will result in a new job file.

          Additionally you can specify the up/ down scripts by setting
          the up down properties. 
          Config lines up=/nix/store/xxx-up-script down=...
          will be appended to your configuration file automatically

          If you define at least one of up/down "script-security 2" will be
          prepended to your config otherwise you scripts aren't run by openvpn

          Don't forget to check that the all package sizes can be sent. For
          examlpe if scp hangs you should set --fragment XXX --mssfix YYY.
        '';

        type = types.attrsOf types.optionSet;
        options = [ openvpnInstanceOptions ];
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    jobs = listToAttrs (mapAttrsFlatten (name: value: nameValuePair "openvpn-${name}" (makeOpenVPNJob value name)) cfg.servers);
  };
  
}
