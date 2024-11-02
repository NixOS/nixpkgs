# Test Traefik as a reverse proxy of a local web service
# and a Docker container.
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "traefik";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ joko ];
  };

  nodes = {
    client = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.curl ];
    };
    traefik = { config, pkgs, ... }: {
      virtualisation.oci-containers = {
        backend = "docker";
        containers.nginx = {
          extraOptions = [
            "-l"
            "traefik.enable=true"
            "-l"
            "traefik.http.routers.nginx.entrypoints=web"
            "-l"
            "traefik.http.routers.nginx.rule=Host(`nginx.traefik.test`)"
          ];
          image = "nginx-container";
          imageStream = pkgs.dockerTools.examples.nginxStream;
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];

      services.traefik = {
        enable = true;

        dynamicConfigOptions = {
          http.routers.simplehttp = {
            rule = "Host(`simplehttp.traefik.test`)";
            entryPoints = [ "web" ];
            service = "simplehttp";
          };

          http.services.simplehttp = {
            loadBalancer.servers = [{
              url = "http://127.0.0.1:8000";
            }];
          };
        };

        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };

          entryPoints.web.address = ":\${HTTP_PORT}";

          providers.docker.exposedByDefault = false;
        };
        environmentFiles = [(pkgs.writeText "traefik.env" ''
          HTTP_PORT=80
        '')];
      };

      systemd.services.simplehttp = {
        script = "${pkgs.python3}/bin/python -m http.server 8000";
        serviceConfig.Type = "simple";
        wantedBy = [ "multi-user.target" ];
      };

      users.users.traefik.extraGroups = [ "docker" ];
    };
  };

  testScript = ''
    start_all()

    traefik.wait_for_unit("docker-nginx.service")
    traefik.wait_until_succeeds("docker ps | grep nginx-container")
    traefik.wait_for_unit("simplehttp.service")
    traefik.wait_for_unit("traefik.service")
    traefik.wait_for_open_port(80)
    traefik.wait_for_unit("multi-user.target")

    client.wait_for_unit("multi-user.target")

    client.wait_until_succeeds("curl -sSf -H Host:nginx.traefik.test http://traefik/")

    with subtest("Check that a container can be reached via Traefik"):
        assert "Hello from NGINX" in client.succeed(
            "curl -sSf -H Host:nginx.traefik.test http://traefik/"
        )

    with subtest("Check that dynamic configuration works"):
        assert "Directory listing for " in client.succeed(
            "curl -sSf -H Host:simplehttp.traefik.test http://traefik/"
        )
  '';
})
