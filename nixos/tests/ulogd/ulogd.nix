import ../make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "ulogd";

    meta.maintainers = with lib.maintainers; [ p-h ];

    nodes.machine =
      { ... }:
      {
        networking.firewall.enable = false;
        networking.nftables.enable = true;
        networking.nftables.ruleset = ''
          table inet filter {
            chain input {
              type filter hook input priority 0;
              icmp type { echo-request, echo-reply } log group 2 accept
            }

            chain output {
              type filter hook output priority 0; policy accept;
              icmp type { echo-request, echo-reply } log group 2 accept
            }

            chain forward {
              type filter hook forward priority 0; policy drop;
            }

          }
        '';
        services.ulogd = {
          enable = true;
          settings = {
            global = {
              logfile = "/var/log/ulogd.log";
              stack = [
                "log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU"
                "log1:NFLOG,base1:BASE,pcap1:PCAP"
              ];
            };

            log1.group = 2;

            pcap1 = {
              sync = 1;
              file = "/var/log/ulogd.pcap";
            };

            emu1 = {
              sync = 1;
              file = "/var/log/ulogd_pkts.log";
            };
          };
        };

        environment.systemPackages = with pkgs; [ tcpdump ];
      };

    testScript = lib.readFile ./ulogd.py;
  }
)
