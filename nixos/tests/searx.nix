{ pkgs, runTest }:

{

  # searx running the built-in webserver
  basic = runTest {
    name = "searx-basic";
    meta.maintainers = pkgs.searxng.meta.maintainers;

    nodes.machine = {
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

    testScript = ''
      with subtest("Settings have been merged"):
          machine.wait_for_unit("searx-init")
          machine.wait_for_file("/run/searx/settings.yml")
          output = machine.succeed(
              "${pkgs.yq-go}/bin/yq eval"
              " '.engines[] | select(.name==\"startpage\") | .shortcut'"
              " /run/searx/settings.yml"
          ).strip()
          assert output == "start", "Settings not merged"

      with subtest("Environment variables have been substituted"):
          machine.succeed("grep -q somesecret /run/searx/settings.yml")
          machine.copy_from_machine("/run/searx/settings.yml")

      with subtest("Basic setup is working"):
          machine.wait_for_open_port(8080)
          machine.wait_for_unit("searx")
          machine.succeed(
              "${pkgs.curl}/bin/curl --fail http://localhost:8080"
          )
    '';
  };

  # searx running in uWSGI with nginx as proxy
  fancy = runTest {
    name = "searx-fancy";
    meta.maintainers = pkgs.searxng.meta.maintainers;

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
      with subtest("Nginx+uWSGI setup is working"):
          fancy.wait_for_open_port(80)
          fancy.wait_for_unit("uwsgi")
          fancy.succeed(
              "${pkgs.curl}/bin/curl --fail http://localhost/searx >&2"
          )

      with subtest("Static files are served"):
          fancy.succeed(
              "${pkgs.curl}/bin/curl --fail http://localhost/searx/static/themes/simple/img/favicon.svg >&2"
          )
    '';
  };

}
