# SPDX-FileCopyrightText: 2025 Gergely Nagy
# SPDX-FileContributor: Gergely Nagy
#
# SPDX-License-Identifier: MIT
{ lib, ... }:
{
  name = "iocaine";
  meta.maintainers = with lib.maintainers; [ poz ];

  nodes = {
    iocaine_default = _: {
      services.iocaine = {
        enable = true;
      };
    };

    iocaine_kdl = _: {
      services.iocaine = {
        enable = true;
        configPaths = [ "/etc/iocaine/config.kdl" ];
      };

      environment.etc."iocaine/config.kdl" = {
        text = ''
          http-server default {
              bind "127.0.0.1:42069"
              use handler-from=default
          }

          declare-handler default language=roto
        '';
      };
    };

    reverse_proxy_integration = _: {
      services.iocaine = {
        enable = true;
        config.server.main = {
          bind = "/tmp/iocaine.socket";
          unix-socket-access = "group";
          mode = "http";
          use = {
            handler-from = "default";
          };
        };
        config.handler.default = { };
      };

      services.caddy = {
        enable = true;
        globalConfig = ''
          http_port 8080
          https_port 8081
        '';
      };

      services.nginx.enable = true;
    };
  };

  testScript = ''
    start_all()

    iocaine_default.wait_for_unit("iocaine.service")
    iocaine_default.fail("curl -s --show-error --fail http://127.0.0.1:42069/random-path/yes/")
    iocaine_default.fail("curl -s --show-error --fail http://127.0.0.1:42069/ -A 'Googlebot'")
    iocaine_default.succeed("curl -s --show-error --fail http://127.0.0.1:42069/a/path/very/deep/into/the/forest/ -A 'Perplexity'")
    iocaine_default.fail("curl -s --show-error --fail http://127.0.0.1:42042/metrics")

    iocaine_kdl.wait_for_unit("iocaine.service")
    iocaine_kdl.fail("curl -s --show-error --fail http://127.0.0.1:42069/random-path/yes/")
    iocaine_kdl.fail("curl -s --show-error --fail http://127.0.0.1:42069/ -A 'Googlebot'")
    iocaine_kdl.succeed("curl -s --show-error --fail http://127.0.0.1:42069/a/path/very/deep/into/the/forest/ -A 'Perplexity'")
    iocaine_kdl.fail("curl -s --show-error --fail http://127.0.0.1:42042/metrics")

    reverse_proxy_integration.wait_for_unit("iocaine.service")
    reverse_proxy_integration.wait_for_unit("caddy.service")
    reverse_proxy_integration.wait_for_unit("nginx.service")
    reverse_proxy_integration.stop_job("nginx")
    reverse_proxy_integration.stop_job("caddy")
    reverse_proxy_integration.stop_job("iocaine")
    reverse_proxy_integration.start_job("nginx")
    reverse_proxy_integration.succeed("systemctl is-active iocaine.service")
    reverse_proxy_integration.stop_job("nginx")
    reverse_proxy_integration.stop_job("iocaine")
    reverse_proxy_integration.start_job("caddy")
    reverse_proxy_integration.succeed("systemctl is-active iocaine.service")
  '';
}
