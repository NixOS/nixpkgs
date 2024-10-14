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
        PUBLIC_BACKEND_URL = "http://localhost/api/";
        BASEROW_DISABLE_PUBLIC_URL_CHECK = "1";
        PRIVATE_BACKEND_URL = "http://[::1]:8000";
        BASEROW_PUBLIC_URL = "http://localhost";
        BASEROW_BACKEND_DEBUG = "on";
        BASEROW_BACKEND_LOG_LEVEL = "DEBUG";
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
          proxyPass = "http://[::1]:3000";
        };
      };
    };
  };

  testScript = { nodes }: ''
    machine.start()
    machine.wait_for_unit("baserow.target")
    machine.wait_for_open_port(8000)

    print(machine.succeed(
        "curl -H 'Host: localhost' -sSfL http://[::1]:8000/api/settings/"
    ))
    # [::1] is not an allowed host.
    machine.fail(
        "curl -sSfL http://[::1]:8000/api/settings/"
    )
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    # Backend
    print(machine.succeed(
        "curl -sSfL http://localhost/api/_health/"
    ))

    # Frontend
    machine.wait_for_unit("baserow-nuxt.service")
    machine.wait_for_open_port(3000)
    # Test connection to backend through frontend
    print(machine.succeed(
        "curl -sSfL http://localhost/login/"
    ))
    print(machine.succeed(
        "curl -sSfL http://localhost/_health/"
    ))
  '';
})
