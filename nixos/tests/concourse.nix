{
  config,
  lib,
  pkgs,
  ...
}:
let
  concoursePackage = pkgs.concourse;
  ccusername = "myuser"; # Name of the user in concourse
  ccpassword = "mypass"; # Password of the user in concourse

  # Generated some 1024 bit keys for demo
  session-signing-key = pkgs.writeTextFile {
    name = "session-signing-key";
    text = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIICXAIBAAKBgQDgqPO8PiA/L51riTTGxHPjGUoxTMxHaq2rDIqONViO22UdRgw6
      Rhc05s6uGDd90/WHx/nFET95y7nKf7T4FpCF756SnV6UEnWsAiZHuYX7M1pNS48i
      t3ps8Zza+PC1rWl0JK8exUnketruCeOt50W99vsd1AhMc7E1d264/Tx71QIDAQAB
      AoGAQjHFzxtHCRcQfRTqVf6gXrOe5rPIJOrLzPBfCtOxCjaermdrRuhMAixXjXhZ
      MVv4pk9HysbwOwTJ8155hfewERkXXxs2VbQ/MZT1oJ2j7kBgGTyfoja6sKiOwUF4
      fJsKrxu3GU0zHgJFEE7jOGC9as0WoI5bHKQyJztTIYd1mUECQQD/GiF9MvEcUV1e
      XykJFHlMUP2FYWyQaCAzIPsDplWZI0jFmRcYnsALH+6eW86xajvPOSKVm59PBcnJ
      zfrPsDVJAkEA4XNj6eAp1Zin/hIwVM0XQY2ZUQZaP2Zpp7cqEF2SK/zap7vW/Uta
      4R6vgVUGvpH9NB8Gw8WKZD3Q8ezUNDAuLQJAWgiE7UT/Z7kntNjtCLFbJh4ne92o
      jUbSpnjrXpxj9YpIcsTXK+9LZCG++9D3IBKYTUii9h5YmXE3iKvT610LUQJAOIfH
      iNBFjSJ/FS0YY1sdtrk7tV5jaLxUR9KcwIfF7DO13BM0oESx3/rixQo967ENjXEu
      MA6rWeFKMC9TMlbWbQJBAIBRyh5tnXZv/gZo/HMOD4AUIvXHURKdgW45AXHeZpwk
      7tH6a+Z6a7+w7E2N+k5F/z8W9pjv6rdqaey7s0utvE8=
      -----END RSA PRIVATE KEY-----
    '';
  };
  tsa-host-key-pub = pkgs.writeTextFile {
    name = "tsa-host-key-pub";
    text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDobnbljTPx+qONY4DSjKGgekPJK/Qcyby0mtW/AXHKXqiKIB9tleOApI8cj8fXTIIj0JfvelggPH+fc60XO5D/svMuZN+rPDf9CyGb4vujvGiG8hJSXRFhqHaaT+YS79u65eEdyOOSbiMxzi3WS5AJ1XAKSNIrFtK84UQ7oAAhww== web@example.org";
  };
  tsa-host-key = pkgs.writeTextFile {
    name = "tsa-host-key";
    text = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIICXAIBAAKBgQDobnbljTPx+qONY4DSjKGgekPJK/Qcyby0mtW/AXHKXqiKIB9t
      leOApI8cj8fXTIIj0JfvelggPH+fc60XO5D/svMuZN+rPDf9CyGb4vujvGiG8hJS
      XRFhqHaaT+YS79u65eEdyOOSbiMxzi3WS5AJ1XAKSNIrFtK84UQ7oAAhwwIDAQAB
      AoGABFSSiIJR9m8p/udcrg+Kr1e3zZaxDJxBlMfRtaZMPW34C+K/UyZYv7vRIsIX
      Ag7d2db4DbEk1SzrX8gi8GzeravKaXetjuAZEGcy26135QGE4EOeyHRS15yIxn/E
      Ik/bcM7HFOktrtJny/y8Fqou+DHlrrQ5DBc7NxQ179AlKEECQQD8/p07tXx3JL/p
      mbEMpFDq4B3q+TR3LYcGFQePugoAdp6FuMlgaeSY2ogh4tYZymzI5ZiMDb3Lr9z6
      5jAeLAbjAkEA6zFQxmhWQkHjjJ1UOtwms8kIRLrAkzhcwb/qRtp1iwSGoS03oSt5
      Zgg2qmPd9k3Q3S6x6htfMAaBQIUJml2PoQJAWp4QT3y38iz1mIR2SCLq4NYZoTpV
      soJaJLGPnclzH6tdKGSBrMkBGkbcD9ch/ObmhCbItxGM89IwAqZEgeofJQJAbP/l
      BJ70Yy6wK8n6cHD5Stc/isLWXyR+8JhmFkJGuY/2aRpQrtQ8Jgpmc19nTjBQPUHX
      2Lyox9Qr8N/3TGBSIQJBAKhogPmaRYCvGFe3mWsRdhaeDrRg5lbB0TC3MPYR/Vov
      OCSM3EeS6Qctz3qujJnFznPhgY5AgRB+Y+Ca7oYFEpw=
      -----END RSA PRIVATE KEY-----
    '';
  };
  worker-key-pub = pkgs.writeTextFile {
    name = "worker-key-pub";
    text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDJ+/kN7sz461BS5/l7GrPxHvVLmrxE+TkAn1/EYuNutnQw9ceFtyOS26DOwKGGcJQm4SqaQQGuPa9SKWR3SSp8ABuYr6m13BAqA3nXxTZtga1Kg3wMCf9bJbfgWav+3IsKAfJzXgMD/lUBbRMZlLPa3A5b+dagGB7PqPmofRs8Tw== worker@example.org";
  };
  worker-key = pkgs.writeTextFile {
    name = "worker-key";
    text = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIICXAIBAAKBgQDJ+/kN7sz461BS5/l7GrPxHvVLmrxE+TkAn1/EYuNutnQw9ceF
      tyOS26DOwKGGcJQm4SqaQQGuPa9SKWR3SSp8ABuYr6m13BAqA3nXxTZtga1Kg3wM
      Cf9bJbfgWav+3IsKAfJzXgMD/lUBbRMZlLPa3A5b+dagGB7PqPmofRs8TwIDAQAB
      AoGATo9UdRjWXFKZ8UUMgdcG+deCrJ9IbsNIaneSdf3IW71XP9u4eMecbHhD+WZu
      7K1I0j5tpYV3M+AGGrzCuKqafONDzw3lAY4b3yJYwZfs55R6xPuLqFch5okGBlr/
      Qhz56oORXTl/zWEBL+A3fCH4HnIGElY+cNEsyF3i/CtwDOECQQDr63VbgAyPDQsL
      esKYBj30GvC8RbgJ8+8/1QwbIWWr6y9BWVMqH96Yomri8mb8bN65Dv9LRhZQiCYm
      i9029cB3AkEA2y0U6Oa4HQL865WMw3gPPYY0MYruzCOg+hExy8rNnOOrxpCkM4Py
      wGbVb49Zf1j/h6USCbqCB7pmeYmDOF1w6QJBAMZZRGYVlnl/AdY48/pU5SmirNvd
      0gmsKW6FdJQq1Axiw2wx6ZX1DXVOuIbuPl/kOK1mSoXC+2fh0BGAbhCTNakCQGx5
      BFc8ELTzDJ+/tRnsqoZFjEFUxFit7Xa12dJFfbt/Bj3QyiNg01ybyFhdNusK7fSB
      IstDziTrANp3z0SvIjkCQHz3H6DkaJYQcweWBDl4d/6Wy0W3ywC99botoPFhCxVi
      lLRnVITE95N3tkTC4jcuD+AKDrExevB3J4SDhqdYi6A=
      -----END RSA PRIVATE KEY-----
    '';
  };
  # Networking configurations
  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };
  interface = "eth1";
  ip = {
    server = "10.0.0.1";
    worker = "10.0.0.10";
  };
  serverPort = 8080;
  dockerPort = 8082;
  serverTSAPort = 2222;
  macAddress = {
    worker = "02:de:ad:be:ef:01";
    client = "02:de:ad:be:ef:02";
  };
in
{
  name = concoursePackage.pname;
  meta.maintainers = with lib.maintainers; [
    lenianiva
  ];

  nodes = {
    # Web interface node
    server =
      let
        # User and database setup on the server system
        username = "concourse";
        database = "concourse";
        password = "random";
      in
      { config, pkgs, ... }:
      {
        users = {
          users.${config.services.concourse-web.user} = {
            description = "Concourse service";
            isSystemUser = true;
            group = "staff";
            useDefaultShell = true;
          };
          groups.staff = {
            name = "staff";
            members = [
              "admin"
              username
              "postgres"
            ];
          };
        };
        services = {
          openssh.enable = true;
          concourse-web = {
            enable = true;
            postgres = {
              inherit database password;
              user = username;
            };
            auto-restart = false;
            network.bind-port = serverPort;
            session-signing-key = "${session-signing-key}";
            tsa = {
              bind-ip = "0.0.0.0";
              bind-port = serverTSAPort;
              host-key = "${tsa-host-key}";
              authorized-keys = "${worker-key-pub}";
            };
            environment = {
              CONCOURSE_ADD_LOCAL_USER = "${ccusername}:${ccpassword}";
              CONCOURSE_MAIN_TEAM_LOCAL_USER = ccusername;
            };
          };
          postgresql = {
            enable = true;
            ensureDatabases = [ database ];
            ensureUsers = [
              {
                name = username;
                ensureDBOwnership = true;
              }
            ];
            authentication = ''
              # type database db-user auth-method map
              local ${username} ${username} peer map=concourse-map
            '';
            identMap = ''
              postgres root postgres
              concourse-map ${username} ${username}
            '';
            initialScript = pkgs.writeText "init-sql-script" ''
              alter user ${username} with password '${password}';
            '';
          };
          dockerRegistry = {
            enable = true;
            port = dockerPort;
            listenAddress = "0.0.0.0";
            openFirewall = true;
          };
        };
        virtualisation.vlans = [ 1 ];
        inherit networking;
        systemd.network.networks."01-eth1" = {
          name = interface;
          networkConfig = {
            DHCPServer = true;
            Address = "${ip.server}/24";
          };
          dhcpServerStaticLeases = [
            {
              MACAddress = macAddress.worker;
              Address = ip.worker;
            }
          ];
        };
      };
    worker =
      { config, pkgs, ... }:
      {
        services = {
          concourse-worker = {
            enable = true;
            auto-restart = false;
            tsa = {
              host = "${ip.server}:${toString serverTSAPort}";
              public-key = "${tsa-host-key-pub}";
              worker-private-key = "${worker-key}";
            };
            runtime = {
              type = "containerd";
              #config = "${guardian-config}";
            };
            environment = {
              CONCOURSE_BIND_IP = "127.0.0.1";
              CONCOURSE_BIND_PORT = "9001";
              #CONCOURSE_GARDEN_EXTERNAL_IP = ip.worker;
              CONCOURSE_CONTAINERD_EXTERNAL_IP = ip.worker;
              #CONCOURSE_CONTAINERD_DNS_PROXY_ENABLE = "true";
              #CONCOURSE_CONTAINERD_ALLOW_HOST_ACCESS = "true";
            };
          };
        };
        virtualisation.containerd.enable = true;
        virtualisation.memorySize = 2047;
        virtualisation.vlans = [ 1 ];
        systemd.network.networks."40-eth1".dhcpV4Config.ClientIdentifier = "mac";
        networking = networking // {
          interfaces.${interface} = {
            useDHCP = true;
            macAddress = macAddress.worker;
          };
        };
      };
    # This instance has the `fly` CLI
    client =
      { config, pkgs, ... }:
      {
        environment = {
          systemPackages = [
            pkgs.fly
          ];
        };
        virtualisation.vlans = [ 1 ];
        virtualisation.docker = {
          enable = true;
          extraOptions = "--insecure-registry ${ip.server}:${toString dockerPort}";
        };
        networking = networking // {
          interfaces.${interface} = {
            useDHCP = true;
          };
        };
      };
  };

  testScript =
    let
      image-name = "busybox";
      image-tag = "hi";
      image-id = "${ip.server}:${toString dockerPort}/${image-name}";
      example-image = pkgs.dockerTools.streamLayeredImage {
        name = image-name;
        tag = image-tag;
        contents = [ pkgs.busybox ];
      };
      target = "mytarget";
      pipeline-name = "example";
      pipeline-example = pkgs.writeTextFile {
        name = "pipeline-example.yaml";
        text = ''
          jobs:
          - name: hello-world-job
            plan:
            - task: hello-world-task
              config:
                # Tells Concourse which type of worker this task should run on
                platform: linux
                image_resource:
                  type: registry-image
                  source:
                    repository: ${image-id}
                    tag: ${image-tag}
                run:
                  path: echo
                  args: ["Hello world!"]
        '';
      };
    in
    ''
      server.start()
      server.wait_for_unit("concourse-web")
      server.wait_for_open_port(${toString serverPort})

      worker.start()

      client.start()

      # Login to concourse
      client.succeed("fly login --target ${target} --concourse-url http://${ip.server}:${toString serverPort} --username ${ccusername} --password ${ccpassword}")
      client.succeed("fly -t ${target} status")
      client.succeed("fly -t ${target} workers -d")

      # Upload an image to the mockup registry
      client.wait_for_unit("docker.service")
      server.wait_for_open_port(${toString dockerPort})
      client.succeed("${example-image} | docker image load")
      client.succeed("docker tag ${image-name}:${image-tag} ${image-id}:${image-tag}")
      server.wait_for_unit("docker-registry.service")
      server.wait_for_open_port(${toString dockerPort})
      client.succeed("docker push ${image-id}:${image-tag}")

      worker.wait_for_unit("concourse-worker")

      # Send a task and wait until it succeeds
      client.succeed("fly -t ${target} set-pipeline -p ${pipeline-name} -c ${pipeline-example} --non-interactive")

      client.succeed("fly -t ${target} unpause-pipeline -p ${pipeline-name}")

      worker.require_unit_state("concourse-worker")
      client.succeed("fly -t ${target} trigger-job --job ${pipeline-name}/hello-world-job --watch")
    '';
}
