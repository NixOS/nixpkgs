import ./make-test-python.nix (
  { pkgs, ... }: let
    domain = "whatever.example.com";
    password = "false;foo;exit;withspecialcharacters";
  in
    {
      name = "iodine";
      nodes = {
        server =
          { ... }:

            {
              networking.firewall = {
                allowedUDPPorts = [ 53 ];
                trustedInterfaces = [ "dns0" ];
              };
              boot.kernel.sysctl = {
                "net.ipv4.ip_forward" = 1;
                "net.ipv6.ip_forward" = 1;
              };

              services.iodine.server = {
                enable = true;
                ip = "10.53.53.1/24";
                passwordFile = "${builtins.toFile "password" password}";
                inherit domain;
              };

              # test resource: accessible only via tunnel
              services.openssh = {
                enable = true;
                openFirewall = false;
              };
            };

        client =
          { ... }: {
            services.iodine.clients.testClient = {
              # test that ProtectHome is "read-only"
              passwordFile = "/root/pw";
              relay = "server";
              server = domain;
            };
            systemd.tmpfiles.rules = [
              "f /root/pw 0666 root root - ${password}"
            ];
            environment.systemPackages = [
              pkgs.nagiosPluginsOfficial
            ];
          };

      };

      testScript = ''
        start_all()

        server.wait_for_unit("sshd")
        server.wait_for_unit("iodined")
        client.wait_for_unit("iodine-testClient")

        client.succeed("check_ssh -H 10.53.53.1")
      '';
    }
)
