/**
   Only `iptables` be supported, for now, and this module assumes following
   NixOS chains have been defined;

  - `-N nixos-fw-accept`
  - `-A nixos-fw -m conntrack --ctstate RELATED,ESTABLISHED -j nixos-fw-accept`

  ...  Additionally, due to `DOCKER` rules having a veracious appetite for local
  addresses, this module will attempt to inject packet jumps prior to
  problematic services.  Testing with other setups will reveal more edge-cases.

   Use some of the following commands to debug issues;

   ```bash
   systemctl status firewall.service

   iptables -L PREROUTING -vn
   iptables -L tor-middle-box-pre -vn

   iptables -S PREROUTING
   iptables -S tor-middle-box-pre

   journalctl -k | grep 'refused connection:.*${localAddress}.*' | less
   ```

   ## Attributions

   - https://gitlab.torproject.org/legacy/trac/-/wikis/doc/TransparentProxy#anonymizing-middlebox
   - https://archive.torproject.org/websites/lists.torproject.org/pipermail/tor-talk/2014-March/032503.html
   - https://archive.torproject.org/websites/lists.torproject.org/pipermail/tor-talk/2014-March/032507.html
   - https://www.dnsleaktest.com/
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    literalExpression
    mkIf
    mkOption
    ;

  inherit (lib.types)
    attrs
    nonEmptyStr
    port
    submodule
    ;

  inherit (pkgs.formats) keyValue;
  keyValueFormat = keyValue { };

  cfgsModule = config.networking.tor.middle-box;
  cfgsTor = config.services.tor;
in
{
  options.networking.tor.middle-box = {
    enable = mkEnableOption "Enable modifying iptables";

    settings = mkOption {
      default = { };

      description = ''
        ## Check `iptables` rules are applied

        ```bash
        iptables -t nat -S PREROUTING | grep 'tor-middle-box-pre' &&
          iptables -t nat -S tor-middle.box-pre
        ```

        Above commands _should_ produce output similar to

        ```
        -A PREROUTING -s 192.168.1.2/32 -j tor-middle-box-pre

        -N tor-middle-box-pre
        -A tor-middle-box-pre -p udp -m udp --dport 53 -j DNAT --to-destination 192.168.122.36:5353
        -A tor-middle-box-pre -p udp -m udp --dport 5353 -j DNAT --to-destination 192.168.122.36:5353
        -A tor-middle-box-pre -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j DNAT --to-destination 192.168.122.36:9040
        ```

        > `192.168.1.2/32` -> `containers.<name>.localAddress`
        > `192.168.122.36` -> `services.tor.settings.TransPort` and/or `DNSPort`

        ## Check DNS lookups work

        ```bash
        ssh tor-client.containers <<'EOF'
          dig google.com
        EOF
        ```

        Above _should_ show using the `torListenAddr` IP for `SERVER`

        ## Check for DNS leaks

        ```bash
        ssh tor-client.containers <<'EOF'
          curl -l https://www.dnsleaktest.com/ |
            pup '.welcome'
        EOF
        ```

        Above _should_ show an external IP different from clear-net host

        ## Check for TCP over Tor

        ```bash
        ssh tor-client.containers <<'EOF'
          curl -l https://check.torproject.org/ |
            pup '.content > .not, .not + p, .security'
        EOF
        ```

        Above _should_ show "Congradulations" for being connected and warnings about not using Tor browser

      '';

      example = literalExpression ''
        { config, ... }:
        let
          containerName = "tor-client";
          containerUser = "your-user";

          torListenAddr = "192.168.122.36";

          stateVersion = "25.05";

          cfgs = config;
          DNSAddr = cfgs.networking.tor.middle-box.settings.DNSPort.addr;
        in
        {
          containers.''${containerName} = {
            autoStart = false;
            privateNetwork = true;

            ## This will bind to host via interface like: `ve-''${containerName}@if2`
            hostAddress = "192.168.3.1";
            ## This will bind to guest via interface like: `eth0@if6`
            localAddress = "192.168.1.2";

            config =
              { lib, pkgs, ... }:
              {
                system.stateVersion = stateVersion;

                networking = {
                  hostName = containerName;
                  useHostResolvConf = lib.mkForce false;
                };

                ## https://github.com/NixOS/nixpkgs/issues/162686
                services.resolved = {
                  enable = true;
                  extraConfig = \'\'
                    nameserver ''${DNSAddr}
                  \'\';
                };
                environment.etc."resolv.conf".text = lib.mkForce \'\'
                  nameserver ''${DNSAddr}
                  options edns0 trust-ad
                  search .
                \'\';

                services.openssh = {
                  enable = true;
                  settings = {
                    PasswordAuthentication = false;
                    KbdInteractiveAuthentication = false;
                    PermitRootLogin = "no";
                    AllowUsers = [ "''${containerUser}" ];
                  };
                };

                users.users.''${containerUser} = {
                  isNormalUser = true;

                  openssh.authorizedKeys.keyFiles = [
                    ## Adjustment likely necessary
                    ../services/openssh/id_rsa.pub
                  ];

                  packages = with pkgs; [
                    dig
                    pup
                  ];
                };
              };
          };

          networking.tor.middle-box = {
            enable = true;
            settings.clients = {
              ''${containerName} = cfgs.containers.''${containerName};
            };
          };

          services.tor = {
            enable = true;
            settings =
              let
                ## WARN: order is important!
                addresses = [
                  "''${torListenAddr}"
                  "127.0.0.1"
                ];
              in
              {
                TransPort = builtins.map (addr: {
                  inherit addr;
                  port = 9040;
                  flags = [
                    "IsolateClientAddr"
                    "IsolateClientProtocol"
                    "IsolateDestAddr"
                    "IsolateDestPort"
                  ];
                }) addresses;

                DNSPort = builtins.map (addr: {
                  inherit addr;
                  port = 5353;
                }) addresses;

                VirtualAddrNetworkIPv4 = "10.192.0.0/10";
                AutomapHostsOnResolve = true;

                ## Following may not be necessary but are nice to have
                SOCKSPort = [ 9050 ];
                HTTPTunnelPort = [ 9999 ];
              };
          };
        }
      '';

      type =
        let
          typeTorAddrPort = submodule {
            freeformType = keyValueFormat.type;
            options = {
              addr = mkOption {
                description = "Address Tor service listens on for clients";
                type = nonEmptyStr;
              };
              port = mkOption {
                description = "Port Tor service listens on for clients";
                type = port;
              };
            };
          };
        in
        submodule {
          options = {
            clients = mkOption {
              default = { };

              description = "Attribute set of clients to forward traffic through Tor network";

              example = literalExpression ''
                {
                  tor-client1.localAddress = "192.168.1.68";
                  tor-client2.localAddress = "192.168.13.36";
                }
              '';

              ## TODO: get smort about requiring `localAddress` to be `nonEmptyStr`
              type = attrs;
            };

            SOCKSPort = mkOption {
              default = builtins.head cfgsTor.settings.SOCKSPort;

              description = "Address and port Tor service listens for SOCKS trafic on";

              example = literalExpression ''
                {
                  addr = "192.168.122.36";
                  port = 9050;
                }
              '';

              type = typeTorAddrPort;
            };

            TransPort = mkOption {
              default = builtins.head cfgsTor.settings.TransPort;

              description = "Address and port Tor service listens for TCP trafic on";

              example = literalExpression ''
                {
                  addr = "192.168.122.36";
                  port = 9040;
                }
              '';

              type = typeTorAddrPort;
            };

            DNSPort = mkOption {
              default = builtins.head cfgsTor.settings.DNSPort;

              description = "Address and port Tor service listens for DNS trafic on";

              example = literalExpression ''
                {
                  addr = "192.168.122.36";
                  port = 5353;
                }
              '';

              type = typeTorAddrPort;
            };

            iptables = mkOption {
              default = { };

              description = "Names of custom `iptables` chain names";

              example = literalExpression ''
                {
                  nat.prerouting = "tor-middle-box-pre";
                }
              '';

              type = submodule {
                options = {
                  nat = mkOption {
                    default = { };
                    description = "Names of chain names for `iptables -t nat` table(s)";
                    type = submodule {
                      options = {
                        prerouting = mkOption {
                          default = "tor-middle-box-pre";
                          description = "Custom chain name for iptables PREROUTING rules";
                          type = nonEmptyStr;
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
    };
  };

  config = mkIf (cfgsModule.enable && cfgsModule.settings != { }) {
    networking.firewall.extraCommands =
      let
        SOCKSPort = cfgsModule.settings.SOCKSPort;
        TransPort = cfgsModule.settings.TransPort;
        DNSPort = cfgsModule.settings.DNSPort;
        chainNamePre = cfgsModule.settings.iptables.nat.prerouting;
      in
      ''
        ## Delete jumps to pre/post-routing chains
        for _table in PREROUTING POSTROUTING; do
          while read -r _line; do
            iptables -t nat $_line;
          done < <(iptables -t nat -S $_table | sed -nE '/-j (${chainNamePre})$/{
            s/^-A/-D/g;
            p;
          }')
        done

        ## Flush and delete chains if they exists
        for _chain in ${chainNamePre}; do
          iptables -t nat -F $_chain 2> /dev/null || true;
          iptables -t nat -X $_chain 2> /dev/null || true;
        done

        iptables -t nat -N ${chainNamePre};
      ''
      + lib.optionalString (DNSPort ? addr && DNSPort ? port) ''
        iptables -t nat -A ${chainNamePre} -p udp --dport 53 -j DNAT --to-destination ${DNSPort.addr}:${toString DNSPort.port};
        iptables -t nat -A ${chainNamePre} -p udp --dport 5353 -j DNAT --to-destination ${DNSPort.addr}:${toString DNSPort.port};
      ''
      + lib.optionalString (SOCKSPort ? addr && SOCKSPort ? port) ''
        iptables -t nat -A ${chainNamePre} -p tcp --dport ${toString SOCKSPort.port} -j DNAT --to-destination ${SOCKSPort.addr}:${toString SOCKSPort.port};
      ''
      + lib.optionalString (SOCKSPort ? port && TransPort ? addr && TransPort ? port) ''
        iptables -t nat -A ${chainNamePre} -p tcp ! --dport ${toString SOCKSPort.port} --syn -j DNAT --to-destination ${TransPort.addr}:${toString TransPort.port};
      ''
      + lib.optionalString ((SOCKSPort ? port == false) && TransPort ? addr && TransPort ? port) ''
        iptables -t nat -A ${chainNamePre} -p tcp --syn -j DNAT --to-destination ${TransPort.addr}:${toString TransPort.port};
      ''
      + builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (_name: value: ''
          ${lib.getExe pkgs.iptables-insert-before} --target '-j DOCKER$' -- -t nat -A PREROUTING -s ${value.localAddress} -j ${chainNamePre};
          ${lib.getExe pkgs.iptables-insert-before} --target '-j nixos-fw-log-refuse$' -- -A nixos-fw -s ${value.localAddress} -j nixos-fw-accept;
        '') (lib.filterAttrs (_name: value: value ? localAddress) cfgsModule.settings.clients)
      );

  };
}
