{ lib, pkgs, ... }:
let
  wg-keys = import ./wireguard/snakeoil-keys.nix;

  target_host = "acme.test";
  server_host = "sing-box.test";

  hosts = {
    "${target_host}" = "1.1.1.1";
    "${server_host}" = "1.1.1.2";
  };
  hostsEntries = lib.mapAttrs' (k: v: {
    name = v;
    value = lib.singleton k;
  }) hosts;

  vmessPort = 1080;
  vmessUUID = "bf000d23-0752-40b4-affe-68f7707a9661";
  vmessInbound = {
    type = "vmess";
    tag = "inbound:vmess";
    listen = "0.0.0.0";
    listen_port = vmessPort;
    users = [
      {
        name = "sekai";
        uuid = vmessUUID;
        alterId = 0;
      }
    ];
  };
  vmessOutbound = {
    type = "vmess";
    tag = "outbound:vmess";
    server = server_host;
    server_port = vmessPort;
    uuid = vmessUUID;
    security = "auto";
    alter_id = 0;
  };

  tunInbound = {
    type = "tun";
    tag = "inbound:tun";
    interface_name = "tun0";
    address = [
      "172.16.0.1/30"
      "fd00::1/126"
    ];
    auto_route = true;
    iproute2_table_index = 2024;
    iproute2_rule_index = 9001;
    route_address = [
      "${hosts."${target_host}"}/32"
    ];
    route_exclude_address = [
      "${hosts."${server_host}"}/32"
    ];
    strict_route = false;
  };

  tproxyPort = 1081;
  tproxyPost = pkgs.writeShellApplication {
    name = "exe";
    runtimeInputs = with pkgs; [
      iproute2
      iptables
    ];
    text = ''
      ip route add local default dev lo table 100
      ip rule add fwmark 1 table 100

      iptables -t mangle -N SING_BOX
      iptables -t mangle -A SING_BOX -d 100.64.0.0/10 -j RETURN
      iptables -t mangle -A SING_BOX -d 127.0.0.0/8 -j RETURN
      iptables -t mangle -A SING_BOX -d 169.254.0.0/16 -j RETURN
      iptables -t mangle -A SING_BOX -d 172.16.0.0/12 -j RETURN
      iptables -t mangle -A SING_BOX -d 192.0.0.0/24 -j RETURN
      iptables -t mangle -A SING_BOX -d 224.0.0.0/4 -j RETURN
      iptables -t mangle -A SING_BOX -d 240.0.0.0/4 -j RETURN
      iptables -t mangle -A SING_BOX -d 255.255.255.255/32 -j RETURN

      iptables -t mangle -A SING_BOX -d ${hosts."${server_host}"}/32 -p tcp -j RETURN
      iptables -t mangle -A SING_BOX -d ${hosts."${server_host}"}/32 -p udp -j RETURN

      iptables -t mangle -A SING_BOX -d ${hosts."${target_host}"}/32 -p tcp -j TPROXY --on-port ${toString tproxyPort} --tproxy-mark 1
      iptables -t mangle -A SING_BOX -d ${hosts."${target_host}"}/32 -p udp -j TPROXY --on-port ${toString tproxyPort} --tproxy-mark 1
      iptables -t mangle -A PREROUTING -j SING_BOX

      iptables -t mangle -N SING_BOX_SELF
      iptables -t mangle -A SING_BOX_SELF -d 100.64.0.0/10 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 127.0.0.0/8 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 169.254.0.0/16 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 172.16.0.0/12 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 192.0.0.0/24 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 224.0.0.0/4 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 240.0.0.0/4 -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d 255.255.255.255/32 -j RETURN
      iptables -t mangle -A SING_BOX_SELF  -j RETURN -m mark --mark 1234

      iptables -t mangle -A SING_BOX_SELF -d ${hosts."${server_host}"}/32 -p tcp -j RETURN
      iptables -t mangle -A SING_BOX_SELF -d ${hosts."${server_host}"}/32 -p udp -j RETURN
      iptables -t mangle -A SING_BOX_SELF -p tcp -j MARK --set-mark 1
      iptables -t mangle -A SING_BOX_SELF -p udp -j MARK --set-mark 1
      iptables -t mangle -A OUTPUT -j SING_BOX_SELF
    '';
  };
in
{

  name = "sing-box";

  meta = {
    maintainers = with lib.maintainers; [
      nickcao
      prince213
    ];
  };

  nodes = {
    target =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = hosts."${target_host}";
                prefixLength = 24;
              }
            ];
          };
        };

        services.dnsmasq.enable = true;

        services.nginx = {
          enable = true;
          package = pkgs.nginxQuic;

          virtualHosts."${target_host}" = {
            onlySSL = true;
            sslCertificate = ./common/acme/server/acme.test.cert.pem;
            sslCertificateKey = ./common/acme/server/acme.test.key.pem;
            http2 = true;
            http3 = true;
            http3_hq = false;
            quic = true;
            reuseport = true;
            locations."/" = {
              extraConfig = ''
                default_type text/plain;
                return 200 "$server_protocol $remote_addr";
                allow ${hosts."${server_host}"}/32;
                deny all;
              '';
            };
          };
        };
      };

    server =
      { pkgs, ... }:
      {
        boot.kernel.sysctl = {
          "net.ipv4.conf.all.forwarding" = 1;
        };

        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = hosts."${server_host}";
                prefixLength = 24;
              }
            ];
          };
        };

        systemd.network.wait-online.ignoredInterfaces = [ "wg0" ];

        networking.wg-quick.interfaces.wg0 = {
          address = [
            "10.23.42.1/24"
          ];
          listenPort = 2408;
          mtu = 1500;

          inherit (wg-keys.peer0) privateKey;

          peers = lib.singleton {
            allowedIPs = [
              "10.23.42.2/32"
            ];

            inherit (wg-keys.peer1) publicKey;
          };

          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.23.42.0/24 -o eth1 -j MASQUERADE
          '';
        };

        services.sing-box = {
          enable = true;
          settings = {
            inbounds = [
              vmessInbound
            ];
            outbounds = [
              {
                type = "direct";
                tag = "outbound:direct";
              }
            ];
            route = {
              default_interface = "eth1";
            };
          };
        };
      };

    tun =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "1.1.1.3";
                prefixLength = 24;
              }
            ];
          };
        };

        security.pki.certificates = [
          (builtins.readFile ./common/acme/server/ca.cert.pem)
        ];

        environment.systemPackages = [
          pkgs.curlHTTP3
          pkgs.iproute2
        ];

        services.sing-box = {
          enable = true;
          settings = {
            inbounds = [
              tunInbound
            ];
            outbounds = [
              {
                type = "block";
                tag = "outbound:block";
              }
              {
                type = "direct";
                tag = "outbound:direct";
              }
              vmessOutbound
            ];
            route = {
              default_interface = "eth1";
              final = "outbound:block";
              rules = [
                {
                  inbound = [
                    "inbound:tun"
                  ];
                  outbound = "outbound:vmess";
                }
              ];
            };
          };
        };
      };

    wireguard =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "1.1.1.4";
                prefixLength = 24;
              }
            ];
          };
        };

        security.pki.certificates = [
          (builtins.readFile ./common/acme/server/ca.cert.pem)
        ];

        environment.systemPackages = [
          pkgs.curlHTTP3
          pkgs.iproute2
        ];

        services.sing-box = {
          enable = true;
          settings = {
            outbounds = [
              {
                type = "block";
                tag = "outbound:block";
              }
            ];
            endpoints = [
              {
                type = "wireguard";
                tag = "outbound:wireguard";
                name = "wg0";
                address = [ "10.23.42.2/32" ];
                mtu = 1280;
                private_key = wg-keys.peer1.privateKey;
                peers = [
                  {
                    address = server_host;
                    port = 2408;
                    public_key = wg-keys.peer0.publicKey;
                    allowed_ips = [ "0.0.0.0/0" ];
                  }
                ];
                system = true;
              }
            ];
            route = {
              default_interface = "eth1";
              final = "outbound:block";
            };
          };
        };
      };

    tproxy =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "1.1.1.5";
                prefixLength = 24;
              }
            ];
          };
        };

        security.pki.certificates = [
          (builtins.readFile ./common/acme/server/ca.cert.pem)
        ];

        environment.systemPackages = [ pkgs.curlHTTP3 ];

        systemd.services.sing-box.serviceConfig.ExecStartPost = [
          "+${tproxyPost}/bin/exe"
        ];

        services.sing-box = {
          enable = true;
          settings = {
            inbounds = [
              {
                tag = "inbound:tproxy";
                type = "tproxy";
                listen = "0.0.0.0";
                listen_port = tproxyPort;
                udp_fragment = true;
              }
            ];
            outbounds = [
              {
                type = "block";
                tag = "outbound:block";
              }
              {
                type = "direct";
                tag = "outbound:direct";
              }
              vmessOutbound
            ];
            route = {
              default_interface = "eth1";
              final = "outbound:block";
              rules = [
                {
                  inbound = [
                    "inbound:tproxy"
                  ];
                  outbound = "outbound:vmess";
                }
              ];
            };
          };
        };
      };

    fakeip =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "1.1.1.6";
                prefixLength = 24;
              }
            ];
          };
        };

        environment.systemPackages = [ pkgs.dnsutils ];

        services.sing-box = {
          enable = true;
          settings = {
            dns = {
              final = "dns:default";
              independent_cache = true;
              servers = [
                {
                  type = "udp";
                  tag = "dns:default";
                  server = hosts."${target_host}";
                }
                {
                  type = "fakeip";
                  tag = "dns:fakeip";
                  inet4_range = "198.18.0.0/16";
                }
                {
                  type = "resolved";
                  tag = "dns:resolved";
                  service = "service:resolved";
                  accept_default_resolvers = true;
                }
              ];
              rules = [
                {
                  query_type = [
                    "A"
                    "AAAA"
                  ];
                  server = "dns:fakeip";
                }
              ];
            };
            inbounds = [
              tunInbound
            ];
            outbounds = [
              {
                type = "block";
                tag = "outbound:block";
              }
              {
                type = "direct";
                tag = "outbound:direct";
              }
            ];
            route = {
              default_domain_resolver = "dns:default";
              default_interface = "eth1";
              final = "outbound:direct";
              rules = [
                {
                  action = "sniff";
                }
                {
                  protocol = "dns";
                  action = "hijack-dns";
                }
              ];
            };
            services = [
              {
                type = "resolved";
                tag = "service:resolved";
              }
            ];
          };
        };
      };
  };

  testScript = ''
    target.wait_for_unit("nginx.service")
    target.wait_for_open_port(443)
    target.wait_for_unit("dnsmasq.service")
    target.wait_for_open_port(53)

    server.wait_for_unit("sing-box.service")
    server.wait_for_open_port(1080)
    server.wait_for_unit("wg-quick-wg0.service")
    server.wait_for_file("/sys/class/net/wg0")

    def test_curl(machine, extra_args=""):
      assert (
        machine.succeed(f"curl --fail --max-time 10 --http2 https://${target_host} {extra_args}")
        == "HTTP/2.0 ${hosts.${server_host}}"
      )
      assert (
        machine.succeed(f"curl --fail --max-time 10 --http3-only https://${target_host} {extra_args}")
        == "HTTP/3.0 ${hosts.${server_host}}"
      )

    with subtest("tun"):
      tun.wait_for_unit("sing-box.service")
      tun.wait_for_unit("sys-devices-virtual-net-${tunInbound.interface_name}.device")
      tun.wait_until_succeeds("ip route get ${hosts."${target_host}"} | grep 'dev ${tunInbound.interface_name}'")
      tun.succeed("ip addr show ${tunInbound.interface_name}")
      tun.succeed("ip route show table ${toString tunInbound.iproute2_table_index} | grep ${tunInbound.interface_name}")
      assert (
        tun.succeed("ip rule list table ${toString tunInbound.iproute2_table_index} | sort | head -1 | awk -F: '{print $1}' | tr -d '\n'")
        == "${toString tunInbound.iproute2_rule_index}"
      )
      test_curl(tun)

    with subtest("wireguard"):
      wireguard.wait_for_unit("sing-box.service")
      wireguard.wait_for_unit("sys-devices-virtual-net-wg0.device")
      wireguard.succeed("ip addr show wg0")
      test_curl(wireguard, "--interface wg0")

    with subtest("tproxy"):
      tproxy.wait_for_unit("sing-box.service")
      test_curl(tproxy)

    with subtest("fakeip"):
      fakeip.wait_for_unit("sing-box.service")
      fakeip.wait_for_unit("sys-devices-virtual-net-${tunInbound.interface_name}.device")
      fakeip.wait_until_succeeds("ip route get ${hosts."${target_host}"} | grep 'dev ${tunInbound.interface_name}'")
      fakeip.succeed("dig +short A ${target_host} @${target_host} | grep '^198.18.'")
  '';

}
