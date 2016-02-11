# Test the firewall module.

import ./make-test.nix ( { pkgs, ... } :
with pkgs.lib;
let
  pingcmd = ip: "\"ping -n -c 1 ${ip} >&2\"";
  ping6cmd = ip: "\"ping6 -n -c 1 ${ip} >&2\"";

  run_ipv4 = true;
  run_ipv6 = true;

  run_site_a = true;
  run_site_b = true;
  run_site_c = true;

  basic_machine = {
    boot.kernel.sysctl = {
      "net.ipv6.conf.eth0.disable_ipv6" = 1;
    };
  };
  basic_client = basic_machine // {
    services.httpd.enable = true;
    services.httpd.adminAddr = "foo@example.org";
    networking.firewall.enable = true;
    networking.firewall.rejectPackets = true;
    networking.firewall.logRefusedPackets = true;
  };
in {
  name = "firewall-router";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes = {
    router = { config, pkgs, nodes, ... }:
    basic_machine // {
      virtualisation.vlans = [ 1 2 3 ];
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };
      networking = {
        interfaces = mkOverride 0 (listToAttrs (flip map [ 1 2 3 ] (n:
          {
            name = "eth${toString n}";
            value = {
              ip4 = [{ address = "192.168.${toString n}.1"; prefixLength = 24; }];
              ip6 = [{ address = "fd0${toString n}\:\:1"; prefixLength = 64; }];
            };
          }
        )));
      };
      networking.nat = {
        enable = true;
        externalInterface = "eth3";
        internalIPs = [ "192.168.1.0/24" ];
      };
      networking.firewall.enable = true;
      networking.firewall.allowPing = false;
      networking.firewall.rejectPackets = true;
      networking.firewall.logRefusedPackets = true;
      networking.firewall.defaultPolicies = {
        input = "DROP";
        forward = "DROP";
        output = "ACCEPT";
      };
      networking.firewall.rules = [
        { chain = "INPUT"; fromInterface = "eth0"; target = "ACCEPT"; }
        { chain = "INPUT"; fromInterface = "eth1"; protocol = "icmp"; target = "ACCEPT"; }
        { chain = "OUTPUT"; toInterface = "eth1"; target = "ACCEPT"; }
        { chain = "OUTPUT"; toInterface = "eth2"; target = "ACCEPT"; }
        { chain = "OUTPUT"; toInterface = "eth3"; target = "ACCEPT"; }
        { chain = "INPUT"; fromInterface = "lo"; target = "ACCEPT"; }
        {
          chain = "FORWARD";
          fromInterface = "eth1";
          toInterface = "eth2";
          protocol = "icmp";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth1";
          toInterface = "eth2";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth2";
          toInterface = "eth1";
          destinationPort = "80";
          protocol = "tcp";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          sourceAddr = "192.168.2.0/24";
          destinationAddr = "192.168.3.0/24";
          target = "LOG";
          log-prefix = "IPTABLES v4 HIT";
        }
        {
          chain = "FORWARD";
          sourceAddr = "fd02::/64";
          destinationAddr = "fd03::/64";
          target = "LOG";
          log-prefix = "IPTABLES v6 HIT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth1";
          toInterface = "eth3";
          sourceAddr = "192.168.1.0/24";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth3";
          toInterface = "eth+";
          protocol = "tcp";
          sourcePort = "1024:65535";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth3";
          toInterface = "eth+";
          protocol = "icmp";
          target = "ACCEPT";
        }
        {
          chain = "FORWARD";
          fromInterface = "eth3";
          toInterface = "eth+";
          protocol = "icmpv6";
          target = "ACCEPT";
        }
      ];
    };

    site_a = { config, pkgs, ... }:
    basic_client // {
      virtualisation.vlans = [ 1 ];
      networking.interfaces.eth1 = mkOverride 0 {
        ip4 = [{ address = "192.168.1.2"; prefixLength = 24;}];
        ip6 = [{ address = "fd01::2"; prefixLength = 64;}];
      };
      networking.defaultGateway = "192.168.1.1";
      networking.defaultGateway6 = "fd01::1";
      networking.firewall.defaultPolicies = {
        input = "ACCEPT";
      };
    };
    site_b = { config, pkgs, ... }:
    basic_client // {
      virtualisation.vlans = [ 2 ];
      networking.interfaces.eth1 = mkOverride 0 {
        ip4 = [{ address = "192.168.2.2"; prefixLength = 24;}];
        ip6 = [{ address = "fd02::2"; prefixLength = 64;}];
      };
      networking.defaultGateway = "192.168.2.1";
      networking.defaultGateway6 = "fd02::1";
      networking.firewall.defaultPolicies = {
        input = "ACCEPT";
      };
    };
    site_c = { config, pkgs, ... }:
    basic_client // {
      virtualisation.vlans = [ 3 ];
      networking.interfaces.eth1 = mkOverride 0 {
        ip4 = [{ address = "192.168.3.2"; prefixLength = 24;}];
        ip6 = [{ address = "fd03::2"; prefixLength = 64;}];
      };
      networking.defaultGateway = "192.168.3.1";
      networking.defaultGateway6 = "fd03::1";
      networking.firewall.defaultPolicies = {
        input = "ACCEPT";
      };
      networking.firewall.rules = [
        {
          sourceAddr = "192.168.1.0/24";
          fromInterface = "eth1";
          target = "REJECT";
        }
      ];
    };
  };

  testScript =
    { nodes, ... }:
    ''
      subtest "Wait for machines", sub {
        startAll;

        $router->waitForUnit("firewall");
        $router->waitForUnit("default.target");

        $site_a->waitForUnit("default.target");
        $site_b->waitForUnit("default.target");
        $site_c->waitForUnit("default.target");
      };

      subtest "check setup", sub {
        $router->execute("systemctl status -l -n 50 firewall >&2");

        ${optionalString run_ipv4
          ''
          $router->execute("ip -4 a >&2");
          $router->execute("ip -4 r >&2");
          $site_a->execute("ip -4 a >&2");
          $site_a->execute("ip -4 r >&2");
          $site_b->execute("ip -4 a >&2");
          $site_c->execute("ip -4 a >&2");
          ''
        }

        ${optionalString run_ipv6
          ''
          $router->execute("ip -6 a >&2");
          $router->execute("ip -6 r >&2");
          $site_a->execute("ip -6 a >&2");
          $site_a->execute("ip -6 r >&2");
          $site_b->execute("ip -6 a >&2");
          $site_c->execute("ip -6 a >&2");
          ''
        }

      };

      subtest "router can see everyone", sub {
        # Check that the router can see everyone
        ${optionalString run_ipv4
          ''
          $router->succeed(${pingcmd "192.168.1.2"});
          $router->succeed(${pingcmd "192.168.2.2"});
          $router->succeed(${pingcmd "192.168.3.2"});
          ''
        }
        ${optionalString run_ipv6
          ''
          $router->succeed("ip -6 r get fd01::2 >&2");
          $router->succeed(${ping6cmd "fd01::2"});
          $router->succeed(${ping6cmd "fd02::2"});
          $router->succeed(${ping6cmd "fd03::2"});
          ''
        }
      };

      ${optionalString run_site_a
        ''
        subtest "site A can access site B native and site C via masquerading (ipv4)", sub {
          ${optionalString run_ipv4
            ''
            $site_a->succeed(${pingcmd "192.168.2.2"});
            $site_a->succeed("curl -q --fail --connect-timeout 1 192.168.2.2 >&2");
            $site_a->succeed(${pingcmd "192.168.3.2"});
            $site_a->succeed("curl -q --fail --connect-timeout 1 192.168.3.2 >&2");
            ''
          }
          ${optionalString run_ipv6
            ''
            $site_a->execute("ip -6 r get fd02::2 >&2");
            $site_a->succeed(${ping6cmd "fd02::2"});
            $site_a->succeed("curl -q --fail --connect-timeout 1 [fd02::2] >&2");
            $site_a->fail(${ping6cmd "fd03::2"});
            $site_a->fail("curl -q --fail --connect-timeout 1 [fd03::2] >&2");
            ''
          }
        };
        ''
      }
      ${optionalString run_site_b
        ''
        subtest "site B can access site A port 80 (no ping) but not site C", sub {
          ${optionalString run_ipv4
            ''
            $site_b->fail(${pingcmd "192.168.1.2"});
            $site_b->succeed("curl -q --fail --connect-timeout 1 192.168.1.2 >&2");
            $site_b->fail(${pingcmd "192.168.3.2"});
            $site_b->fail("curl -q --fail --connect-timeout 1 192.168.3.2 >&2");
            $router->succeed("journalctl |grep \"IPTABLES v4 HIT\" >&2");
            ''
          }
          ${optionalString run_ipv6
            ''
            $site_b->fail(${ping6cmd "fd01::2"});
            $site_b->succeed("curl -q --fail --connect-timeout 1 [fd01::2] >&2");
            $site_b->fail(${ping6cmd "fd03::2"});
            $site_b->fail("curl -q --fail --connect-timeout 1 [fd03::2] >&2");
            $router->succeed("journalctl |grep \"IPTABLES v6 HIT\" >&2");
            ''
          }
        };
        ''
      }
      ${optionalString run_site_c
        ''
        subtest "site C can access site A and site B", sub {
          ${optionalString run_ipv4
            ''
            $site_c->succeed(${pingcmd "192.168.1.2"});
            $site_c->succeed("curl -q --fail --connect-timeout 1 192.168.1.2 >&2");
            $site_c->succeed(${pingcmd "192.168.2.2"});
            $site_c->succeed("curl -q --fail --connect-timeout 1 192.168.2.2 >&2");
            ''
          }
          ${optionalString run_ipv6
            ''
            $site_c->succeed(${ping6cmd "fd01::2"});
            $site_c->succeed("curl -q --fail --connect-timeout 1 [fd01::2] >&2");
            $site_c->succeed(${ping6cmd "fd02::2"});
            $site_c->succeed("curl -q --fail --connect-timeout 1 [fd02::2] >&2");
            ''
          }
        };
        ''
      }

      subtest "iptables debug", sub {
        # Output rules for debugging
        $router->execute("iptables -L -nv >&2");
        $router->execute("iptables -t nat -L -nv >&2");
        $router->execute("ip6tables -L -nv >&2");
        $router->execute("ip6tables -t nat -L -nv >&2");
        $site_a->execute("iptables -L -nv >&2");
        $site_a->execute("ip6tables -L -nv >&2");
      };

      subtest "reload firewall", sub {
        $router->succeed("systemctl reload firewall.service >&2");
        $router->waitForUnit("firewall");
        ${optionalString run_ipv4
          ''$site_a->succeed(${pingcmd "192.168.2.2"});''
        }
        ${optionalString run_ipv6
          ''$site_a->succeed(${ping6cmd "fd02::2"});''
        }
      };
    '';
})
