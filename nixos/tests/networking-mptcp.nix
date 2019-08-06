# Test whether `networking.mptcp' works as expected.
# 1/ creates 2 multihomed VMs
# 2/ selects the redundant scheduler to ensure packets are sent on all links
# 3/ start tshark to capture on concerned interfaces while running an iperf session
# 4/ load the recorded pcap and display the interfaces that received MPTCP traffic
# 5/ Use shell-foo to make sure it's equal to the number of interfaces of the host
import ./make-test.nix ({ pkgs, ...} :
let
  vlans = [ 1 0 ];

  default-config = {

    services.xserver.enable = false;

    # else crashes
    virtualisation.memorySize = 512;

    programs.wireshark.enable = true;

    networking = {
      networkmanager.enable = true;
      useDHCP = false;
    };

    environment.systemPackages = with pkgs; [
      iperf3
    ];

    networking.mptcp = {
      enable = true;
      debug = true;
      # we choose the redundant scheduler to ensure traffic is sent on all interfaces
      scheduler = "redundant";
    };

    # create 2 networks
    virtualisation.vlans = vlans;

    # get rid of the default user interface that mess up interface assignment
    virtualisation.qemu.networkingOptions = [ ];

  };
in
{
  name = "networking-mptcp";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ teto ];
  };

  nodes = {
    client = default-config;

    server = { ... }:
      default-config // {
        services.iperf3 = {
          enable = true;
          openFirewall = true;
        };
      };
  };

  testScript =
    ''
      startAll;


      $client->waitForUnit("network.target");
      $server->waitForUnit("network.target");

      print $client->execute("ip addr");
      print $server->execute("ip addr");

      $client->mustSucceed("dmesg | grep MPTCP");
      $server->mustSucceed("dmesg | grep MPTCP");

      # Test ICMP.
      $client->succeed("ping -c 1 server >&2");
      $server->succeed("ping -c 1 client >&2");

      $client->mustSucceed("tshark -i eth0 -i eth1 -a duration:30 -f 'tcp' -w test.pcap &");

      # iperf test: sends -n <bytes> or -t <seconds>, -b limits bitrate
      $client->execute("iperf -c server -t 5 -b 1KiB");

      $client->waitUntilSucceeds("tshark -2 -R 'mptcp' -r test.pcap -Tfields -e frame.interface_id > packet_interfaces.txt");
      my ($retcode, $output) = $client->execute("head packet_interfaces.txt");
      if ($retcode != 0) {
        die "tshark could not load from test.pcap"
      }

      $output = $client->succeed("cat packet_interfaces.txt|uniq|wc -l");
      if (int($output) == ${toString (builtins.length vlans)}) {
        print $output;
        die "Not all interfaces have been used to send MPTCP traffic"
      }

      print ($client->execute("ip route show table eth0"));
      print "Client table eth1\n";
      print ($client->execute("ip route show table eth1"));
      print "\n";
      print "Server table eth0\n";
      print ($server->execute("ip route show table eth0"));
      print "Server table eth1";
      print ($server->execute("ip route show table eth1"));

    '';
})

