{
  lib,
  pkgs,
  ...
}:
{
  name = "reaction-core-plugins";

  nodes.server =
    { config, pkgs, ... }:
    let
      banFor = name: duration: {
        ban_ipset = {
          type = "ipset";
          options = {
            set = "reaction-${name}";
            action = "add";
          };
        };
        ban_nftables = {
          type = "nftables";
          options = {
            set = "reaction-${name}";
            action = "add";
          };
        };
        notify_virtual = {
          type = "virtual";
          options = {
            send = "banned <ip>";
            to = "audit";
          };
        };
        ban_httpban = {
          type = "httpban";
          options = {
            set = "banned";
            action = "add";
          };
        };
        unban_ipset = {
          after = duration;
          type = "ipset";
          options = {
            set = "reaction-${name}";
            action = "del";
          };
        };
        unban_nftables = {
          after = duration;
          type = "nftables";
          options = {
            set = "reaction-${name}";
            action = "delete";
          };
        };
        unban_virtual = {
          after = duration;
          type = "virtual";
          options = {
            send = "unbanned <ip>";
            to = "audit";
          };
        };
        unban_httpban = {
          after = duration;
          type = "httpban";
          options = {
            set = "banned";
            action = "delete";
          };
        };
      };

      journalctl = "${config.systemd.package}/bin/journalctl";
    in
    {
      services.nginx = {
        enable = true;
        virtualHosts."backend" = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 8000;
            }
          ];
          locations."/".return = "200 'backend ok'";
        };
      };

      services.reaction = {
        enable = true;
        stopForFirewall = false;
        runAsRoot = false;
        settings = {
          plugins = {
            # NOTE: When runAsRoot is true, disable run0
            # In the qemu vm `run0 ls` as root prints nothing, so we can't use it
            # see https://reaction.ppom.me/reference.html#systemd
            /*
              ipset.systemd = false;
              virtual.systemd = false;
            */
            ipset.enable = true;
            virtual.enable = true;
            nftables.enable = true;
            httpban = {
              enable = true;
              options = {
                socket = {
                  path = "/run/reaction/httpban.sock";
                  mode = "777";
                };
                downstream_count = 1;
                upstreams = {
                  backend = {
                    host = "127.0.0.1:8000";
                  };
                };
                locations = {
                  "example.test" = {
                    case = {
                      set = "banned";
                      code = 403;
                      inline = "Forbidden by reaction";
                    };
                    default = {
                      upstream = "backend";
                    };
                  };
                };
              };
            };
          };

          patterns = {
            ip = {
              type = "ip";
              ipv6mask = 64;
              ignore = [
                "127.0.0.1"
                "::1"
              ];
              ignorecidr = [
                "10.1.1.0/24"
                "2a01:e0a:b3a:1dd0::/64"
              ];
            };
          };

          streams = {
            ssh = {
              cmd = [
                journalctl
                "-fn0"
                "-o"
                "cat"
                "-u"
                "sshd.service"
              ];
              filters = {
                failedlogin = {
                  regex = [
                    "authentication failure;.*rhost=<ip>(?: |$)"
                    "Failed password for .* from <ip> port"
                    "Invalid user .* from <ip> "
                    "Connection (?:reset|closed) by invalid user .* <ip> port"
                  ];
                  retry = 2;
                  retryperiod = "6h";
                  actions = banFor "ssh" "48h";
                };
                connectionreset = {
                  regex = [
                    "Connection (?:reset|closed) by(?: authenticating user .*)? <ip> port"
                    "Received disconnect from <ip> port .*[preauth]"
                    "Timeout before authentication for connection from <ip> to"
                  ];
                  retry = 2;
                  retryperiod = "6h";
                  actions = banFor "ssh" "48h";
                };
              };
            };
            audit = {
              type = "virtual";
              filters = {
                log_ban = {
                  regex = [ "^banned <ip>$" ];
                  actions = {
                    write_log = {
                      cmd = [
                        "${pkgs.bash}/bin/sh"
                        "-c"
                        "echo 'banned <ip>' >> /var/lib/reaction/virtual.log"
                      ];
                    };
                  };
                };
                log_unban = {
                  regex = [ "^unbanned <ip>$" ];
                  actions = {
                    write_log = {
                      cmd = [
                        "${pkgs.bash}/bin/sh"
                        "-c"
                        "echo 'unbanned <ip>' >> /var/lib/reaction/virtual.log"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      /*
        NOTE:
          - if reaction is run as non-root, the plugins need these capabilities, remove these if runAsRoot is true
          - CAP_DAC_READ_SEARCH is for journalctl for accessing ssh logs
          - useful tools: capable (from package bcc), captree, getpcaps (from libpcap)
      */
      systemd.services.reaction.serviceConfig = {
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_DAC_READ_SEARCH"
        ];
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_DAC_READ_SEARCH"
        ];
      };

      networking.useDHCP = false;
      services.openssh = {
        enable = true;
        hostKeys = [
          {
            type = "ed25519";
            path = "/etc/ssh/ssh_host_ed25519_key";
          }
        ];
      };
      users.users.nixos.isNormalUser = true; # neeeded to establish a ssh connection, by default root login is succeeding without any password

      environment.systemPackages = [
        pkgs.curl
        pkgs.ipset
        pkgs.nftables
      ];
    };

  nodes.client = _: {
    networking.useDHCP = false;
    environment.systemPackages = [
      pkgs.sshpass
      pkgs.libressl.nc
    ];
  };

  testScript =
    { nodes, ... }: # py
    ''
      server.start()
      server.wait_for_unit("multi-user.target")
      server.wait_for_unit("reaction.service")
      server.wait_for_unit("sshd.service")
      server.wait_for_unit("nginx.service")
      server.wait_for_file("/run/reaction/httpban.sock")

      client.start()
      client.wait_for_unit("multi-user.target")

      client_addr = "${(lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address}"
      server_addr = "${(lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address}"

      def curl_httpban(ip):
        return server.succeed(
          f"curl -s -w '\\nHTTP_CODE:%{{http_code}}' --unix-socket /run/reaction/httpban.sock -H 'Host: example.test' -H 'X-Forwarded-For: {ip}' http://example.test/"
        )

      with subtest("initial state before bans"):
        server.succeed("nft list table inet reaction")
        server.succeed("nft list set inet reaction reaction-sshv4")
        server.succeed(f"reaction show | grep -q {client_addr} || test $? -eq 1")

        client.wait_until_succeeds(f"nc -w3 -z {server_addr} 22")

        output = curl_httpban(client_addr)
        assert "backend ok" in output and "HTTP_CODE:200" in output

      with subtest("trigger bans via authentication failure"):
        for _ in range(2):
          client.fail(f"""
            sshpass -p 'wrongpassword' \
              ssh -o StrictHostKeyChecking=no \
                -o User=nixos \
                -o ServerAliveInterval=2 \
                -o ServerAliveCountMax=3 \
                {server_addr}
          """)
        server.wait_until_succeeds(f"reaction show | grep -q {client_addr}")
        output = server.succeed("reaction show")
        print(output)
        assert client_addr in output, f"client did not get banned, {client_addr}"

      with subtest("verify all plugins applied the ban"):
        # 1. ipset plugin
        server.wait_until_succeeds(f"ipset list reaction-sshv4 | grep -q {client_addr}")

        # 2. nftables plugin
        server.wait_until_succeeds(f"nft list set inet reaction reaction-sshv4 | grep -q {client_addr}")

        # 3. virtual plugin
        server.wait_until_succeeds(f"grep -q 'banned {client_addr}' /var/lib/reaction/virtual.log")

        # 4. httpban plugin
        output = curl_httpban(client_addr)
        assert "Forbidden by reaction" in output and "HTTP_CODE:403" in output

        # Non-banned IP still passes through httpban
        output = curl_httpban("192.168.1.99")
        assert "backend ok" in output and "HTTP_CODE:200" in output

        # Verify there is a ban and the port is unreachable from the client.
        client.fail(f"nc -w3 -z {server_addr} 22")

      with subtest("check that unbanning works"):
        server.succeed("reaction flush")

        # 1. ipset cleared
        server.wait_until_fails(f"ipset list reaction-sshv4 | grep -q {client_addr}")

        # 2. nftables set cleared
        server.wait_until_fails(f"nft list set inet reaction reaction-sshv4 | grep -q {client_addr}")

        # 3. virtual plugin unban event
        server.wait_until_succeeds(f"grep -q 'unbanned {client_addr}' /var/lib/reaction/virtual.log")

        # 4. httpban cleared
        server.wait_until_succeeds(
          f"curl -s -f --unix-socket /run/reaction/httpban.sock -H 'Host: example.test' -H 'X-Forwarded-For: {client_addr}' http://example.test/ | grep 'backend ok'"
        )

        # Check we are unbanned
        client.wait_until_succeeds(f"nc -w3 -z {server_addr} 22")
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.reaction.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true;

  interactive.nodes.server =
    { config, ... }:
    {
      # not needed, only for manual interactive debugging
      virtualisation.memorySize = 4096;
      virtualisation.graphics = false;
      environment.systemPackages = with pkgs; [
        btop
        sysz
        sshpass
        libressl.nc
      ];
    };

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
    ]
    ++ lib.teams.ngi.members;
}
