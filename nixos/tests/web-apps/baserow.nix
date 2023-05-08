import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "baserow";

  meta = with lib.maintainers; {
    maintainers = [ raitobezarius julienmalka ];
  };

  nodes.machine = { ... }: {
    services.baserow = {
      enable = true;
      environment = {
        # Needed for the frontend.
        BASEROW_PUBLIC_URL = "http://localhost";
        # Ensure we are allowed to do those requests.
        BASEROW_EXTRA_ALLOWED_HOSTS	= "localhost,[::1],127.0.0.1";
      };
      # Do not do this in production.
      secretFile = pkgs.writeText "secret" ''
      SECRET_KEY=aaaaaaaaaaaaaaaaaaaaaaaa
      '';
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."localhost" = {
        locations."~ ^/(api|ws)/" = {
          proxyPass = "http://[::1]:8000";
          proxyWebsockets = true;
        };
        locations."/media/" = {
          extraConfig = ''
            if ($arg_dl) {
              add_header Content-disposition "attachment; filename=$arg_dl";
            }
            alias /var/lib/baserow/media;
          '';
        };
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };

  testScript = { nodes }: ''
    machine.start()
    machine.wait_for_unit("baserow.target")
    machine.wait_for_open_port(8000)
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    # Backend
    print(machine.succeed(
        "curl -sSfL http://localhost/api/settings/"
    ))

    # Frontend
    machine.wait_for_open_port(3000)
  '';
})
