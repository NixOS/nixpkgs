# Testing out the substitute server with two machines in a local network. As a
# bonus, we'll also test a feature of the substitute server being able to
# advertise its service to the local network with Avahi.

import ../make-test-python.nix ({ pkgs, lib, ... }: let
  publishPort = 8181;
  inherit (builtins) toString;
in {
  name = "guix-publish";

  meta.maintainers = with lib.maintainers; [ foo-dogsquared ];

  nodes = let
    commonConfig = { config, ... }: {
      # We'll be using '--advertise' flag with the
      # substitute server which requires Avahi.
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
    };
  in {
    server = { config, lib, pkgs, ... }: {
      imports = [ commonConfig ];

      services.guix = {
        enable = true;
        publish = {
          enable = true;
          port = publishPort;

          generateKeyPair = true;
          extraArgs = [ "--advertise" ];
        };
      };

      networking.firewall.allowedTCPPorts = [ publishPort ];
    };

    client = { config, lib, pkgs, ... }: {
      imports = [ commonConfig ];

      services.guix = {
        enable = true;

        extraArgs = [
          # Force to only get all substitutes from the local server. We don't
          # have anything in the Guix store directory and we cannot get
          # anything from the official substitute servers anyways.
          "--substitute-urls='http://server.local:${toString publishPort}'"

          # Enable autodiscovery of the substitute servers in the local
          # network. This machine shouldn't need to import the signing key from
          # the substitute server since it is automatically done anyways.
          "--discover=yes"
        ];
      };
    };
  };

  testScript = ''
    import pathlib

    start_all()

    scripts_dir = pathlib.Path("/etc/guix/scripts")

    for machine in machines:
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("guix-daemon.service")
      machine.wait_for_unit("avahi-daemon.service")

    server.wait_for_unit("guix-publish.service")
    server.wait_for_open_port(${toString publishPort})
    server.succeed("curl http://localhost:${toString publishPort}/")

    # Now it's the client turn to make use of it.
    substitute_server = "http://server.local:${toString publishPort}"
    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")
    response = client.succeed(f"curl {substitute_server}")
    assert "Guix Substitute Server" in response

    # Authorizing the server to be used as a substitute server.
    client.succeed(f"curl -O {substitute_server}/signing-key.pub")
    client.succeed("guix archive --authorize < ./signing-key.pub")

    # Since we're using the substitute server with the `--advertise` flag, we
    # might as well check it.
    client.succeed("avahi-browse --resolve --terminate _guix_publish._tcp | grep '_guix_publish._tcp'")
  '';
})
