
{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      openvpn = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the Secure Shell daemon, which allows secure
            remote logins.
          ";
        };
        servers = mkOption {
          example = [
            {
              id = "server-simplest";
              config = ''
                # Most simple configuration: http://openvpn.net/index.php/documentation/miscellaneous/static-key-mini-howto.html.
                # server : 
                dev tun
                ifconfig 10.8.0.1 10.8.0.2
                secret static.key
              '';
              up = "ip route add ..!";
              down = "ip route add ..!";
            }
            {
              id = "client-simplest";
              config = ''
                #client:
                #remote myremote.mydomain
                #dev tun
                #ifconfig 10.8.0.2 10.8.0.1
                #secret static.key
              '';
            }
            {
              id = "server-scalable";
              config = ''
                multiple clienst
                see example file found in http://openvpn.net/index.php/documentation/howto.html
              '';
            }
            {
              id = "client-scalabe";
              config = '' dito '';
            }
          ];
          default = [];
          description = ''
            openvpn instances to be run. Each will be put into an extra job named openvpn-{id}

            The up and down properties will be added config line up=/nix/store/xxx-up-script
            automatically for you. If you define at least one of up/down
            "script-security 2" will be prepended to your config.

            Don't forget to check that the all package sizes can be sent. if scp hangs or such you should set
            --fragment XXX --mssfix YYY.
          '';
        };
      };
    };
  };


  modprobe = config.system.sbin.modprobe;

###### implementation

  cfg = config.services.openvpn;

  inherit (pkgs) openvpn;
  inherit (builtins) hasAttr;

  PATH="${pkgs.iptables}/sbin:${pkgs.coreutils}/bin:${pkgs.iproute}/sbin:${pkgs.nettools}/sbin";

  makeOpenVPNJob = cfg :
    let
      upScript = ''
        #!/bin/sh
        exec &> /var/log/openvpn-${cfg.id}-up
        PATH=${PATH}
        ${cfg.up}
      '';
      downScript = ''
        #!/bin/sh
        exec &> /var/log/openvpn-${cfg.id}-down
        PATH=${PATH}
        ${cfg.down}
      '';
      configFile = pkgs.writeText "openvpn-config-${cfg.id}" ''
      ${if hasAttr "up" cfg || hasAttr "down" cfg then "script-security 2" else ""}
      ${cfg.config}
      ${if hasAttr "up" cfg then "up ${pkgs.writeScript "openvpn-${cfg.id}-up" upScript}" else "" }
      ${if hasAttr "down" cfg then "down ${pkgs.writeScript "openvpn-${cfg.id}-down" downScript}" else "" }
      '';
    in {
      name = "openvpn-${cfg.id}";

      job = ''
        description "OpenVPN-${cfg.id}"

        start on network-interfaces/started
        stop on network-interfaces/stop


        PATH=${pkgs.coreutils}/bin

        respawn
        script
          exec &> /var/log/openvpn-${cfg.id}
          ${modprobe} tun || true
          ${openvpn}/sbin/openvpn --config ${configFile}
        end script
      '';
    };

in


mkIf cfg.enable {
  require = [
    options
  ];

  services = {
    extraJobs = map makeOpenVPNJob cfg.servers;
  };
}
