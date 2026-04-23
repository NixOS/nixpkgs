{ lib, pkgs, ... }:

{
  name = "searx";
  meta = with lib.maintainers; {
    maintainers = [
      SuperSandro2000
      _999eagle
    ];
  };

  # basic setup: searx running the built-in webserver
  nodes.base = {
    services.searx = {
      enable = true;
      environmentFile = pkgs.writeText "secrets" ''
        SEARX_SECRET_KEY = somesecret
      '';

      settings = {
        engines = [
          {
            name = "startpage";
            shortcut = "start";
          }
        ];
        plugins = { };
        server = {
          port = "8080";
          bind_address = "0.0.0.0";
          secret_key = "$SEARX_SECRET_KEY";
        };
      };
    };

  };

  # fancy setup: run in uWSGI and use nginx as proxy
  nodes.fancy =
    { config, lib, ... }:
    {
      services.searx = {
        enable = true;
        settings = {
          plugins = { };
          server.secret_key = "somesecret";
        };

        configureNginx = true;
        domain = "localhost";
        uwsgiConfig = {
          # use /searx as url "mountpoint"
          mount = "/searx=searx.webapp:application";
          module = "";
          manage-script-name = true;
        };
      };

      services.nginx.virtualHosts.${config.services.searx.domain} = {
        locations = {
          "/static/" = lib.mkForce { };
          "/searx/static/".alias = "${config.services.searx.package}/share/static/";
        };
      };
    };

  testScript = ''
    base.start()

    with subtest("Settings have been merged"):
        base.wait_for_unit("searx-init")
        base.wait_for_file("/run/searx/settings.yml")
        output = base.succeed(
            "${pkgs.yq-go}/bin/yq eval"
            " '.engines[] | select(.name==\"startpage\") | .shortcut'"
            " /run/searx/settings.yml"
        ).strip()
        assert output == "start", "Settings not merged"

    with subtest("Environment variables have been substituted"):
        base.succeed("grep -q somesecret /run/searx/settings.yml")
        base.copy_from_vm("/run/searx/settings.yml")

    with subtest("Basic setup is working"):
        base.wait_for_open_port(8080)
        base.wait_for_unit("searx")
        base.succeed(
            "${pkgs.curl}/bin/curl --fail http://localhost:8080"
        )
        base.shutdown()

    with subtest("Nginx+uWSGI setup is working"):
        fancy.start()
        fancy.wait_for_open_port(80)
        fancy.wait_for_unit("uwsgi")
        fancy.succeed(
            "${pkgs.curl}/bin/curl --fail http://localhost/searx >&2"
        )
        fancy.succeed(
            "${pkgs.curl}/bin/curl --fail http://localhost/searx/static/themes/simple/js/searxng.core.min.js >&2"
        )
  '';
}
