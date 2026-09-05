# Test Traefik as a reverse proxy of a local web service
# and a Docker container.
{ lib, ... }:
{
  name = "traefik";
  meta = with lib.maintainers; {
    maintainers = [
      joko
      jackr
      therealgramdalf
    ];
  };

  # Debugging
  # To view the configuration of a container, load nixpkgs into `nix repl` and access
  # `outputs.legacyPackages.x86_64-linux.nixosTests.traefik.containers.<name>.config`

  # Prevent devnet being enabled automatically by declaring both nodes and containers in the same test
  # since this feature isn't enabled on nixpkgs infrastructure
  requiredFeatures.devnet = lib.mkForce false;

  defaults = {
    services.traefik.install.settings = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      entryPoints."web".address = ":80";
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  containers = {
    # Central client
    # This emulates a network request coming in to the server over the network, rather than
    # routing everything through localhost. #defenseindepth.
    "client" =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };

    # Reusable http server
    # Note that this doesn't cover the case of proxying a service hosted on the same machine through localhost,
    # that could be added to the docker test without much overhead
    "simplehttp" =
      { pkgs, ... }:
      {
        systemd.services.simplehttp = {
          script = "${pkgs.python3}/bin/python -m http.server 80";
          serviceConfig.Type = "simple";
          wantedBy = [ "multi-user.target" ];
        };
      };

    # Test objectives:
    # - Declarative install/routing configuration through routing.settings (is this actually being loaded by traefik?)
    # - Auto merge of dangling `routing.extraFiles` (has the merge logic been foiled somehow?)
    #   - Do multiple extraFiles get merged properly (without overwriting eachother)
    "declare" = {
      services.traefik = {
        enable = true;
        routing.settings = {
          http.routers."declarativehttp" = {
            rule = "Host(`declarativehttp.declare`)";
            entryPoints = [ "web" ];
            service = "declarativehttp";
          };

          http.services."declarativehttp".loadBalancer.servers = [
            {
              url = "http://simplehttp";
            }
          ];
        };

        routing.extraFiles = {
          "extrahttp1".settings = {
            http.routers."extrahttp1" = {
              rule = "Host(`extrahttp1.declare`)";
              entryPoints = [ "web" ];
              service = "extrahttp1";
            };

            http.services."extrahttp1".loadBalancer.servers = [
              {
                url = "http://simplehttp";
              }
            ];
          };
          "extrahttp2".settings = {
            http.routers."extrahttp2" = {
              rule = "Host(`extrahttp2.declare`)";
              entryPoints = [ "web" ];
              service = "extrahttp2";
            };

            http.services."extrahttp2".loadBalancer.servers = [
              {
                url = "http://simplehttp";
              }
            ];
          };
        };

      };
    };

    # Test objectives:
    # - Ensure that `routing.extraFiles` are being:
    #   - generated
    #   - loaded by traefik
    #   - given the correct permissions in the simple case of `user == traefik` and `group == traefik`
    "extra" = {
      services.traefik = {
        enable = true;

        routing = {
          dir = "/etc/traefik/routing";

          extraFiles."extrahttp".settings = {
            http.routers."extrahttp" = {
              rule = "Host(`extrahttp.extra`)";
              entryPoints = [ "web" ];
              service = "extrahttp";
            };

            http.services."extrahttp".loadBalancer.servers = [
              {
                url = "http://simplehttp";
              }
            ];
          };
        };
      };
    };
  };

  # Test objectives:
  # - Ensure that `providers.docker` functions as intended in the simplest case:
  #   - labels are parsed by `traefik`
  #   - networking between containers and the traefik daemon is functional
  # - If no `routing` configuration is defined, the default logic of install options do not error
  # Note that to [@therealgramdalf's] knowledge, this setup relies on containers joining the
  # default network created by docker. I am unsure if this is the case when traefik is running in a container as well.
  nodes."docker" =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];

      services.traefik = {
        enable = true;
        supplementaryGroups = [ "docker" ];
        # Prevent traefik from creating a router automatically based on EXPOSE directives in the docker image
        install.settings.providers.docker.exposedByDefault = false;
      };

      virtualisation.oci-containers = {
        backend = "docker";
        containers."nginx" = {
          labels = {
            "traefik.enable" = "true";
            # Service is automatically created
            "traefik.http.routers.nginx.entrypoints" = "web";
            "traefik.http.routers.nginx.rule" = "Host(`nginx.docker`)";
          };
          image = "nginx-container";
          imageStream = pkgs.dockerTools.examples.nginxStream;
        };
      };
    };

  testScript = ''
    start_all()

    client.wait_for_unit("multi-user.target")
    simplehttp.wait_for_unit("simplehttp.service")
    simplehttp.wait_for_open_port(80)
    simplehttp.wait_for_unit("multi-user.target")

    declare.wait_for_unit("traefik.service")
    declare.wait_for_open_port(80)
    declare.wait_for_unit("multi-user.target")

    extra.wait_for_unit("traefik.service")
    extra.wait_for_open_port(80)
    extra.wait_for_unit("multi-user.target")

    with subtest("Check that the declarative routing configuration works"):
        assert "Directory listing for " in client.succeed(
            "curl -sSf -H Host:declarativehttp.declare http://declare/"
        )

    with subtest("Check that the first auto merged declarative extraFiles routing configuration works"):
        assert "Directory listing for " in client.succeed(
            "curl -sSf -H Host:extrahttp1.declare http://declare/"
        )

    with subtest("Check that the second auto merged declarative extraFiles routing configuration works"):
        assert "Directory listing for " in client.succeed(
            "curl -sSf -H Host:extrahttp2.declare http://declare/"
        )

    with subtest("Check that the declarative extraFiles routing configuration works"):
        assert "Directory listing for " in client.succeed(
            "curl -sSf -H Host:extrahttp.extra http://extra/"
        )

    docker.wait_for_unit("traefik.service")
    docker.wait_for_open_port(80)
    docker.wait_for_unit("docker-nginx.service")
    docker.wait_until_succeeds("docker ps | grep nginx-container")
    docker.wait_for_unit("multi-user.target")

    # Not needed?
    # client.wait_until_succeeds("curl -sSf -H Host:nginx.docker http://docker/")

    with subtest("Check that a docker container can be reached via Traefik"):
        assert "Hello from NGINX" in docker.succeed(
            "curl -sSf -H Host:nginx.docker http://127.0.0.1/"
        )
  '';
}
