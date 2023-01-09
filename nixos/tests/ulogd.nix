import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "ulogd";

  meta = with lib; {
    maintainers = with maintainers; [ p-h ];
  };

  nodes.machine = { ... }: {
    networking.firewall.enable = false;
    networking.nftables.enable = true;
    networking.nftables.ruleset = ''
      table inet filter {
        chain input {
          type filter hook input priority 0;
          log group 2 accept
        }

        chain output {
          type filter hook output priority 0; policy accept;
          log group 2 accept
        }

        chain forward {
          type filter hook forward priority 0; policy drop;
          log group 2 accept
        }

      }
    '';
    services.ulogd = {
      enable = true;
      settings = {
        global = {
          logfile = "/var/log/ulogd.log";
          stack = "log1:NFLOG,base1:BASE,pcap1:PCAP";
        };

        log1.group = 2;

        pcap1 = {
          file = "/var/log/ulogd.pcap";
          sync = 1;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      tcpdump
    ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("ulogd.service")
    machine.wait_for_unit("network-online.target")

    with subtest("Ulogd is running"):
        machine.succeed("pgrep ulogd >&2")

    # All packets show up twice in the logs
    with subtest("Logs are collected"):
        machine.succeed("ping -f 127.0.0.1 -c 5 >&2")
        machine.succeed("sleep 2")
        machine.wait_until_succeeds("du /var/log/ulogd.pcap >&2")
        _, echo_request_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 8 and host 127.0.0.1")
        expected, actual = 5*2, len(echo_request_packets.splitlines())
        assert expected == actual, f"Expected {expected} packets, got: {actual}"
        _, echo_reply_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 0 and host 127.0.0.1")
        expected, actual = 5*2, len(echo_reply_packets.splitlines())
        assert expected == actual, f"Expected {expected} packets, got: {actual}"

    with subtest("Reloading service reopens log file"):
        machine.succeed("mv /var/log/ulogd.pcap /var/log/old_ulogd.pcap")
        machine.succeed("systemctl reload ulogd.service")
        machine.succeed("ping -f 127.0.0.1 -c 5 >&2")
        machine.succeed("sleep 2")
        _, echo_request_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 8 and host 127.0.0.1")
        expected, actual = 5*2, len(echo_request_packets.splitlines())
        assert expected == actual, f"Expected {expected} packets, got: {actual}"
        _, echo_reply_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 0 and host 127.0.0.1")
        expected, actual = 5*2, len(echo_reply_packets.splitlines())
        assert expected == actual, f"Expected {expected} packets, got: {actual}"
  '';
})
