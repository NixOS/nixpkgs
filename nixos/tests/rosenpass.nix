import ./make-test-python.nix ({ pkgs, ... }:
let
  deviceName = "rp0";

  server = {
    ip = "fe80::1";
    wg = {
      public = "mQufmDFeQQuU/fIaB2hHgluhjjm1ypK4hJr1cW3WqAw=";
      secret = "4N5Y1dldqrpsbaEiY8O0XBUGUFf8vkvtBtm8AoOX7Eo=";
      listen = 10000;
    };
  };
  client = {
    ip = "fe80::2";
    wg = {
      public = "Mb3GOlT7oS+F3JntVKiaD7SpHxLxNdtEmWz/9FMnRFU=";
      secret = "uC5dfGMv7Oxf5UDfdPkj6rZiRZT2dRWp5x8IQxrNcUE=";
    };
  };
in
{
  name = "rosenpass";

  nodes =
    let
      shared = peer: { config, modulesPath, ... }: {
        imports = [ "${modulesPath}/services/networking/rosenpass.nix" ];

        boot.kernelModules = [ "wireguard" ];

        services.rosenpass = {
          enable = true;
          defaultDevice = deviceName;
          settings = {
            verbosity = "Verbose";
            public_key = "/etc/rosenpass/pqpk";
            secret_key = "/etc/rosenpass/pqsk";
          };
        };

        networking.firewall.allowedUDPPorts = [ 9999 ];

        systemd.network = {
          enable = true;
          networks."rosenpass" = {
            matchConfig.Name = deviceName;
            networkConfig.IPv4Forwarding = true;
            networkConfig.IPv6Forwarding = true;
            address = [ "${peer.ip}/64" ];
          };

          netdevs."10-rp0" = {
            netdevConfig = {
              Kind = "wireguard";
              Name = deviceName;
            };
            wireguardConfig.PrivateKeyFile = "/etc/wireguard/wgsk";
          };
        };

        environment.etc."wireguard/wgsk" = {
          text = peer.wg.secret;
          user = "systemd-network";
          group = "systemd-network";
        };
      };
    in
    {
      server = {
        imports = [ (shared server) ];

        networking.firewall.allowedUDPPorts = [ server.wg.listen ];

        systemd.network.netdevs."10-${deviceName}" = {
          wireguardConfig.ListenPort = server.wg.listen;
          wireguardPeers = [
            {
              AllowedIPs = [ "::/0" ];
              PublicKey = client.wg.public;
            }
          ];
        };

        services.rosenpass.settings = {
          listen = [ "0.0.0.0:9999" ];
          peers = [
            {
              public_key = "/etc/rosenpass/peers/client/pqpk";
              peer = client.wg.public;
            }
          ];
        };
      };
      client = {
        imports = [ (shared client) ];

        systemd.network.netdevs."10-${deviceName}".wireguardPeers = [
          {
            AllowedIPs = [ "::/0" ];
            PublicKey = server.wg.public;
            Endpoint = "server:${builtins.toString server.wg.listen}";
          }
        ];

        services.rosenpass.settings.peers = [
          {
            public_key = "/etc/rosenpass/peers/server/pqpk";
            endpoint = "server:9999";
            peer = server.wg.public;
          }
        ];
      };
    };

  testScript = { ... }: ''
    from os import system

    # Full path to rosenpass in the store, to avoid fiddling with `$PATH`.
    rosenpass = "${pkgs.rosenpass}/bin/rosenpass"

    # Path in `/etc` where keys will be placed.
    etc = "/etc/rosenpass"

    start_all()

    for machine in [server, client]:
        machine.wait_for_unit("multi-user.target")

    # Gently stop Rosenpass to avoid crashes during key generation/distribution.
    for machine in [server, client]:
        machine.execute("systemctl stop rosenpass.service")

    for (name, machine, remote) in [("server", server, client), ("client", client, server)]:
        pk, sk = f"{name}.pqpk", f"{name}.pqsk"
        system(f"{rosenpass} gen-keys --force --secret-key {sk} --public-key {pk}")
        machine.copy_from_host(sk, f"{etc}/pqsk")
        machine.copy_from_host(pk, f"{etc}/pqpk")
        remote.copy_from_host(pk, f"{etc}/peers/{name}/pqpk")

    for machine in [server, client]:
        machine.execute("systemctl start rosenpass.service")

    for machine in [server, client]:
        machine.wait_for_unit("rosenpass.service")

    with subtest("ping"):
        client.succeed("ping -c 2 -i 0.5 ${server.ip}%${deviceName}")

    with subtest("preshared-keys"):
        # Rosenpass works by setting the WireGuard preshared key at regular intervals.
        # Thus, if it is not active, then no key will be set, and the output of `wg show` will contain "none".
        # Otherwise, if it is active, then the key will be set and "none" will not be found in the output of `wg show`.
        for machine in [server, client]:
            machine.wait_until_succeeds("wg show all preshared-keys | grep --invert-match none", timeout=5)
  '';

  # NOTE: Below configuration is for "interactive" (=developing/debugging) only.
  interactive.nodes =
    let
      inherit (import ./ssh-keys.nix pkgs) snakeOilPublicKey snakeOilPrivateKey;

      sshAndKeyGeneration = {
        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
        environment.systemPackages = [
          (pkgs.writeShellApplication {
            name = "gen-keys";
            runtimeInputs = [ pkgs.rosenpass ];
            text = ''
              HOST="$(hostname)"
              if [ "$HOST" == "server" ]
              then
                PEER="client"
              else
                PEER="server"
              fi

              # Generate keypair.
              mkdir -vp /etc/rosenpass/peers/$PEER
              rosenpass gen-keys --force --secret-key /etc/rosenpass/pqsk --public-key /etc/rosenpass/pqpk

              # Set up SSH key.
              mkdir -p /root/.ssh
              cp ${snakeOilPrivateKey} /root/.ssh/id_ecdsa
              chmod 0400 /root/.ssh/id_ecdsa

              # Copy public key to other peer.
              # shellcheck disable=SC2029
              ssh -o StrictHostKeyChecking=no $PEER "mkdir -pv /etc/rosenpass/peers/$HOST"
              scp /etc/rosenpass/pqpk "$PEER:/etc/rosenpass/peers/$HOST/pqpk"
            '';
          })
        ];
      };

      # Use kmscon <https://www.freedesktop.org/wiki/Software/kmscon/>
      # to provide a slightly nicer console, and while we're at it,
      # also use a nice font.
      # With kmscon, we can for example zoom in/out using [Ctrl] + [+]
      # and [Ctrl] + [-]
      niceConsoleAndAutologin.services.kmscon = {
        enable = true;
        autologinUser = "root";
        fonts = [{
          name = "Fira Code";
          package = pkgs.fira-code;
        }];
      };
    in
    {
      server = sshAndKeyGeneration // niceConsoleAndAutologin;
      client = sshAndKeyGeneration // niceConsoleAndAutologin;
    };
})
