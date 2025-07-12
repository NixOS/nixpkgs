{
  config,
  pkgs,
  lib,
  ...
}:
let
  hexChars = lib.stringToCharacters "0123456789abcdef";
  isHexString = s: lib.all (c: lib.elem c hexChars) (lib.stringToCharacters (lib.toLower s));
  baseHexStringType = lib.types.str;
  hexString = (lib.types.addCheck baseHexStringType isHexString) // {
    name = "hexadecimalString";
    description = "hexadecimal string with no 0x prefix";
  };
  hexNumber =
    (lib.types.addCheck baseHexStringType (n: isHexString (lib.strings.removePrefix "0x" n)))
    // {
      name = "hexadecimalNumber";
      description = "integer in base-16 encoding";
    };
in
{
  options.services.openthread-border-router = {
    enable = lib.mkEnableOption "Enable an OpenThread Border Router";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The OpenThread Border Router package to use";
      default = pkgs.openthread-border-router;
      defaultText = "pkgs.openthread-border-router";
    };
    web = {
      enable = lib.mkOption {
        description = "Enable the web management GUI";
        type = lib.types.bool;
        default = true;
      };
      listenAddress = lib.mkOption {
        description = "The address to bind the frontend GUI";
        type = lib.types.str;
        default = "::1";
      };
      listenPort = lib.mkOption {
        description = "The port for the frontend GUI";
        type = lib.types.port;
        default = 55534;
      };
    };
    radioProtocol = lib.mkOption {
      description = "The protocol used to connect to the radio coprocessor";
      default = "spinel+hdlc+uart://";
      type = lib.types.str;
    };
    radioDevice = lib.mkOption {
      description = "The device file for the radio coprocessor";
      example = "/dev/ttyUSB0";
      type = lib.types.path;
    };
    infrastructureInterface = lib.mkOption {
      description = "The IPv6 interface to bridge the Thread network to";
      example = "eth0";
      type = lib.types.str;
    };
    logLevel = lib.mkOption {
      description = "The log level (EMERG=0, ALERT=1, CRIT=2, ERR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7)";
      type = lib.types.ints.between 0 7;
      default = 5;
    };
    threadInterface = lib.mkOption {
      description = "The Thread interface name to create";
      default = "wpan0";
      type = lib.types.str;
    };
    configureAvahi = lib.mkOption {
      description = "Set required Avahi options";
      type = lib.types.bool;
      default = true;
    };
    openFirewall = lib.mkOption {
      description = "Open the firewall port for the server's REST API";
      default = true;
      type = lib.types.bool;
    };
    rest.listenAddress = lib.mkOption {
      default = "::1";
      type = lib.types.str;
      description = "The network address to listen on for the REST API";
    };
    rest.listenPort = lib.mkOption {
      default = 8081;
      type = lib.types.port;
      description = "The network port to listen on for the REST API";
    };

    settingsScript = {
      enable = lib.mkOption {
        description = "Generate a script to run after service start to configure the daemon.";
        type = lib.types.bool;
        default = true;
      };
      dataset = {
        channel = lib.mkOption {
          description = "The IEEE 802.15.4 channel to use.";
          type = lib.types.ints.between 0 26;
          default = 25;
        };
        wakeUpChannel = lib.mkOption {
          description = "The IEEE 802.15.4 wake-up channel to use.";
          type = lib.types.ints.between 0 26;
          default = 26;
        };
        channelMask = lib.mkOption {
          description = "The allowable channel mask, in hexadecimal.";
          default = "0x07fff800";
          type = hexNumber;
        };
        threadDomain = lib.mkOption {
          description = "Thread domain for multi-network roaming.";
          default = "DefaultDomain";
          type = lib.types.str;
        };
        panID = lib.mkOption {
          description = "The IEEE 802.15.4 PAN ID for the network.";
          type = hexNumber;
        };
        extendedPanID = lib.mkOption {
          description = "The IEEE 802.15.4 extended PAN ID for the network.";
          type = hexString;
        };
        meshLocalPrefix = lib.mkOption {
          description = "The mesh-local prefix for the network. Must be a /64.";
          type = lib.types.str;
        };
        commissionerCredentialFile = lib.mkOption {
          description = "A file specifying the Commissioner Credential. Generate the contents of this file using the `pksc` command.";
          type = lib.types.path;
        };
        networkName = lib.mkOption {
          description = "The network name.";
          type = lib.types.str;
        };
        networkKeyFile = lib.mkOption {
          description = "The path to a file containing the network key.";
          type = lib.types.nullOr lib.types.path;
          default = null;
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ spacekitteh ];
  };

  config =
    let
      cfg = config.services.openthread-border-router;
      otbr = cfg.package;
      dataset = cfg.settingsScript.dataset;
      threadInterface = cfg.threadInterface;
      accessInterface = cfg.infrastructureInterface;
      radioURI = "${cfg.radioProtocol}${cfg.radioDevice}";
      forwardIngressChain = "OTBR_FORWARD_INGRESS";
      otctl = lib.getExe' otbr "ot-ctl";

    in
      lib.mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
          [ cfg.rest.listenPort ] ++ (lib.optional cfg.web.enable cfg.web.listenPort)
        );

        services.avahi = lib.mkIf cfg.configureAvahi {
          enable = lib.mkForce true;
          ipv6 = true;
          reflector = true;
          publish = {
            enable = true;
            userServices = true;
          };
          nssmdns6 = true;

          # Is this needed?
          wideArea = true;
        };

        systemd.services.otbr-web = lib.mkIf cfg.web.enable {
          serviceConfig = {
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
            Restart = "on-failure";
            RestartSec = 5;
            RestartPreventExitStatus = "SIGKILL";
          };
          requires = [ "otbr.service" ];
          after = [ "otbr.service" ];
          wantedBy = [ "multi-user.target" ];
          path = [ otbr ];
          script = "${otbr}/bin/otbr-web -d ${builtins.toString cfg.logLevel} -I ${threadInterface} -a ${cfg.web.listenAddress} -p ${builtins.toString cfg.web.listenPort}";

        };

        boot.kernel.sysctl = {
          "net.ipv6.conf.${accessInterface}.accept_ra_rt_info_max_plen" = 64;
          "net.ipv6.conf.${accessInterface}.accept_ra" = 2;
        };

        systemd.services.otbr = {
          serviceConfig = {
            KillMode = "mixed";
            AmbientCapabilities = [
              "CAP_NET_ADMIN"
              "CAP_NET_RAW"
              "CAP_MKNOD"
            ];
            CapabilityBoundingSet = [
              "CAP_NET_ADMIN"
              "CAP_NET_RAW"
              "CAP_MKNOD"
            ];
          };
          wantedBy = [ "network-online.target" ];
          requires = [ "dbus.socket" ];
          after = [ "dbus.socket" ] ;
          

          script = "${otbr}/bin/otbr-agent --rest-listen-address ${cfg.rest.listenAddress} --rest-listen-port ${builtins.toString cfg.rest.listenPort} --syslog-disable --verbose -d ${builtins.toString cfg.logLevel} -I ${threadInterface} -B ${accessInterface} ${radioURI} trel://${accessInterface}";
          postStart = lib.mkIf cfg.settingsScript.enable ''
          ${lib.getExe pkgs.expect} -f  ${./openthread-border-router-setup.exp} ${otctl} ${dataset.networkName} ${dataset.panID} ${dataset.extendedPanID} ${
            if dataset.networkKeyFile == null then "null" else dataset.networkKeyFile
          } ${dataset.commissionerCredentialFile} ${dataset.meshLocalPrefix} ${dataset.channelMask} ${builtins.toString dataset.channel} ${builtins.toString dataset.wakeUpChannel} ${dataset.threadDomain}
        '';
          path = [
            otbr
            pkgs.ipset
            pkgs.iptables
          ];          
          postStop = ''
          ipset_destroy_if_exist()
          {
              if ipset list "$1"; then
                  ipset destroy "$1"
              fi
          }
          while ip6tables -C FORWARD -o ${threadInterface} -j ${forwardIngressChain}; do
              ip6tables -D FORWARD -o ${threadInterface} -j ${forwardIngressChain}
          done

          if ip6tables -L ${forwardIngressChain}; then
              ip6tables -w -F ${forwardIngressChain}
              ip6tables -w -X ${forwardIngressChain}
          fi

          ipset_destroy_if_exist otbr-ingress-deny-src
          ipset_destroy_if_exist otbr-ingress-deny-src-swap
          ipset_destroy_if_exist otbr-ingress-allow-dst
          ipset_destroy_if_exist otbr-ingress-allow-dst-swap
        '';
          preStart = ''
          ipset create -exist otbr-ingress-deny-src hash:net family inet6
          ipset create -exist otbr-ingress-deny-src-swap hash:net family inet6
          ipset create -exist otbr-ingress-allow-dst hash:net family inet6
          ipset create -exist otbr-ingress-allow-dst-swap hash:net family inet6

          ip6tables -N ${forwardIngressChain}
          ip6tables -I FORWARD 1 -o ${threadInterface} -j ${forwardIngressChain}

          ip6tables -A ${forwardIngressChain} -m pkttype --pkt-type unicast -i ${threadInterface} -j DROP
          ip6tables -A ${forwardIngressChain} -m set --match-set otbr-ingress-deny-src src -j DROP
          ip6tables -A ${forwardIngressChain} -m set --match-set otbr-ingress-allow-dst dst -j ACCEPT
          ip6tables -A ${forwardIngressChain} -m pkttype --pkt-type unicast -j DROP
          ip6tables -A ${forwardIngressChain} -j ACCEPT
        '';
        };

        warnings =
          let
            sub2_4GHzPhy =
              lib.trivial.mod (lib.fromHexString dataset.channelMask) (lib.fromHexString "0x0800") != 0;
          in
            lib.optional sub2_4GHzPhy "OpenThread Border Router has been configured with a channel mask which
       includes a sub-2.4GHz IEEE 802.15.4 channel. While there appears to be
       support for this in OpenThread, it is not in the Thread standard itself,
       as of Thread 1.4.";

        assertions =
          let
            pow = lib.fix (
              self: base: power:
              if power != 0 then base * (self base (power - 1)) else 1
            );
            channelBit = pow 2 dataset.channel;
            wakeupBit = pow 2 dataset.wakeUpChannel;
          in
            [
              {
                assertion = config.services.avahi.enable;
                message = "Avahi is currently the only supported mDNS implementation for OpenThread Border Router.";
              }
              {
                assertion = (lib.fromHexString dataset.channelMask) <= (lib.fromHexString "0x7FFFFFF");
                message = "Thread channel mask must be a hexadecimal-encoded 27-bit bitstring.";
              }
              {
                assertion = (lib.bitAnd (lib.fromHexString dataset.channelMask) channelBit) != 0;
                message = "The Thread channel mask excludes the chosen channel.";
              }
              {
                assertion = (lib.bitAnd (lib.fromHexString dataset.channelMask) wakeupBit) != 0;
                message = "The Thread channel mask excludes the chosen wake-up channel.";
              }

            ];
      };
}
