import ./make-test-python.nix ({ pkgs, ... }:
  let address = "192.168.3.1";
  in {
    name = "knockd";

    nodes = {
      knockd = { pkgs, ... }: {
        imports = [ ../modules/profiles/minimal.nix ];

        environment.systemPackages = with pkgs; [ iptables iproute ];

        networking.interfaces.eth1.ipv4.addresses = [{
          inherit address;
          prefixLength = 24;
        }];

        services.sshd.enable = true;

        services.knockd = {
          enable = true;
          options.interface = "eth1";
          knocks = {
            openSSH = {
              sequence = "7000,8000,9000";
              seq_timeout = 10;
              tcpflags = "syn";
              start_command = "iptables -A INPUT -s %IP% --dport 22 -j ACCEPT";
            };
            closeSSH = {
              sequence = "9000,8000,7000";
              seq_timeout = 10;
              tcpflags = "syn";
              start_command = "iptables -D INPUT -s %IP% --dport 22 -j ACCEPT";
            };
          };
        };
      };

      knock = { pkgs, ... }: {
        imports = [ ../modules/profiles/minimal.nix ];

        environment.systemPackages = with pkgs; [ knock netcat-gnu ];
      };
    };

    testScript = ''
      start_all()
      knockd.wait_for_unit("knockd.service")
      knockd.wait_for_unit("sshd.service")
      knock.wait_for_unit("multi-user.target")

      with subtest("closing SSH port"):
          knock.succeed("knock ${address} 9000 8000 7000")
          knock.fail("nc -zv ${address} 22")

      with subtest("opening SSH port"):
          knock.succeed("knock ${address} 7000 8000 9000")
          knock.succeed("nc -zv ${address} 22")
    '';
  })
