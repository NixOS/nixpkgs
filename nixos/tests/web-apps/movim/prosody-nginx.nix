import ../../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    movim = {
      domain = "movim.local";
      info = "No ToS in tests";
      description = "NixOS testing server";
    };
    prosody = {
      domain = "prosody.local";
      admin = rec {
        JID = "${username}@${prosody.domain}";
        username = "romeo";
        password = "juliet";
      };
    };
  in
  {
    name = "movim-prosody-nginx";

    meta = {
      maintainers = with pkgs.lib.maintainers; [ toastal ];
    };

    nodes = {
      server =
        { pkgs, ... }:
        {
          services.movim = {
            inherit (movim) domain;
            enable = true;
            verbose = true;
            podConfig = {
              inherit (movim) description info;
              xmppdomain = prosody.domain;
            };
            nginx = { };
          };

          services.prosody = {
            enable = true;
            xmppComplianceSuite = false;
            disco_items = [
              {
                url = "upload.${prosody.domain}";
                description = "File Uploads";
              }
            ];
            virtualHosts."${prosody.domain}" = {
              inherit (prosody) domain;
              enabled = true;
              extraConfig = ''
                Component "pubsub.${prosody.domain}" "pubsub"
                    pubsub_max_items = 10000
                    expose_publisher = true

                Component "upload.${prosody.domain}" "http_file_share"
                    http_external_url = "http://upload.${prosody.domain}"
                    http_file_share_expires_after = 300 * 24 * 60 * 60
                    http_file_share_size_limit = 1024 * 1024 * 1024
                    http_file_share_daily_quota = 4 * 1024 * 1024 * 1024
              '';
            };
            extraConfig = ''
              pep_max_items = 10000

              http_paths = {
                  file_share = "/";
              }
            '';
          };

          networking.extraHosts = ''
            127.0.0.1 ${movim.domain}
            127.0.0.1 ${prosody.domain}
          '';
        };
    };

    testScript = # python
      ''
        server.wait_for_unit("phpfpm-movim.service")
        server.wait_for_unit("nginx.service")
        server.wait_for_open_port(80)

        server.wait_for_unit("prosody.service")
        server.succeed('prosodyctl status | grep "Prosody is running"')
        server.succeed("prosodyctl register ${prosody.admin.username} ${prosody.domain} ${prosody.admin.password}")

        server.wait_for_unit("movim.service")

        # Test unauthenticated
        server.fail("curl -L --fail-with-body --max-redirs 0 http://${movim.domain}/chat")

        # Test basic Websocket
        server.succeed("echo \"\" | ${lib.getExe pkgs.websocat} 'ws://${movim.domain}/ws/?path=login&offset=0' --origin 'http://${movim.domain}'")

        # Test login + create cookiejar
        login_html = server.succeed("curl --fail-with-body -c /tmp/cookies http://${movim.domain}/login")
        assert "${movim.description}" in login_html
        assert "${movim.info}" in login_html

        # Test authentication POST
        server.succeed("curl --fail-with-body -b /tmp/cookies -X POST --data-urlencode 'username=${prosody.admin.JID}' --data-urlencode 'password=${prosody.admin.password}' http://${movim.domain}/login")

        server.succeed("curl -L --fail-with-body --max-redirs 1 -b /tmp/cookies http://${movim.domain}/chat")
      '';
  }
)
