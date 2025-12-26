{ hostPkgs, lib, ... }:

let
  movim = {
    domain = "movim.local";
    port = 8080;
    info = "No ToS in tests";
    description = "NixOS testing server";
  };
  ejabberd = {
    domain = "ejabberd.local";
    ports = {
      c2s = 5222;
      s2s = 5269;
      http = 5280;
    };
    spoolDir = "/var/lib/ejabberd";
    admin = rec {
      JID = "${username}@${ejabberd.domain}";
      username = "romeo";
      password = "juliet";
    };
  };

  # START OF EJABBERD CONFIG ##################################################
  #
  # Ejabberd has sparse defaults as it is a generic XMPP server. As such this
  # config might be longer than expected for a test.
  #
  # Movim suggests: https://github.com/movim/movim/wiki/Configure ejabberd
  #
  # In the future this may be the default setup
  # See: https://github.com/NixOS/nixpkgs/pull/312316
  ejabberd_config_file =
    let
      settingsFormat = hostPkgs.formats.yaml { };
    in
    settingsFormat.generate "ejabberd.yml" {
      loglevel = "info";
      hide_sensitive_log_data = false;
      hosts = [ ejabberd.domain ];
      default_db = "mnesia";
      acme.auto = false;
      s2s_access = "s2s";
      s2s_use_starttls = false;
      new_sql_schema = true;
      acl = {
        admin = [
          { user = ejabberd.admin.JID; }
        ];
        local.user_regexp = "";
        loopback.ip = [
          "127.0.0.1/8"
          "::1/128"
        ];
      };
      access_rules = {
        c2s = {
          deny = "blocked";
          allow = "all";
        };
        s2s = {
          allow = "all";
        };
        local.allow = "local";
        announce.allow = "admin";
        configure.allow = "admin";
        pubsub_createnode.allow = "local";
        trusted_network.allow = "loopback";
      };
      api_permissions = {
        "console commands" = {
          from = [ "ejabberd_ctl" ];
          who = "all";
          what = "*";
        };
      };
      shaper = {
        normal = {
          rate = 3000;
          burst_size = 20000;
        };
        fast = 100000;
      };
      modules = {
        mod_caps = { };
        mod_disco = { };
        mod_mam = { };
        mod_http_upload = {
          docroot = "${ejabberd.spoolDir}/uploads";
          dir_mode = "0755";
          file_mode = "0644";
          get_url = "http://@HOST@/upload";
          put_url = "http://@HOST@/upload";
          max_size = 65536;
          custom_headers = {
            Access-Control-Allow-Origin = "http://@HOST@,http://${movim.domain}";
            Access-Control-Allow-Methods = "GET,HEAD,PUT,OPTIONS";
            Access-Control-Allow-Headers = "Content-Type";
          };
        };
        # This PubSub block is required for Movim to work.
        #
        # See: https://github.com/movim/movim/wiki/Configure ejabberd#pubsub
        mod_pubsub = {
          hosts = [ "pubsub.@HOST@" ];
          access_createnode = "pubsub_createnode";
          ignore_pep_from_offline = false;
          last_item_cache = false;
          max_items_node = 2048;
          default_node_config = {
            max_items = 2048;
          };
          plugins = [
            "flat"
            "pep"
          ];
          force_node_config = {
            "storage:bookmarks".access_model = "whitelist";
            "eu.siacs.conversations.axolotl.*".access_model = "open";
            "urn:xmpp:bookmarks:0" = {
              access_model = "whitelist";
              send_last_published_item = "never";
              max_items = "infinity";
              persist_items = true;
            };
            "urn:xmpp:bookmarks:1" = {
              access_model = "whitelist";
              send_last_published_item = "never";
              max_items = "infinity";
              persist_items = true;
            };
            "urn:xmpp:pubsub:movim-public-subscription" = {
              access_model = "whitelist";
              max_items = "infinity";
              persist_items = true;
            };
            "urn:xmpp:microblog:0" = {
              notify_retract = true;
              max_items = "infinity";
              persist_items = true;
            };
            "urn:xmpp:microblog:0:comments*" = {
              access_model = "open";
              notify_retract = true;
              max_items = "infinity";
              persist_items = true;
            };
          };
        };
        mod_stream_mgmt = { };
      };
      listen = [
        {
          module = "ejabberd_c2s";
          port = ejabberd.ports.c2s;
          max_stanza_size = 262144;
          access = "c2s";
          starttls_required = false;
        }
        {
          module = "ejabberd_s2s_in";
          port = ejabberd.ports.s2s;
          max_stanza_size = 524288;
          shaper = "fast";
        }
        {
          module = "ejabberd_http";
          port = ejabberd.ports.http;
          request_handlers = {
            "/upload" = "mod_http_upload";
          };
        }
      ];
    };
  # END OF EJABBERD CONFIG ##################################################
in
{
  name = "movim-ejabberd-h2o";

  meta = {
    maintainers = with lib.maintainers; [ toastal ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          # For testing
          pkgs.websocat
        ];

        services.movim = {
          inherit (movim) domain port;
          enable = true;
          verbose = true;
          podConfig = {
            inherit (movim) description info;
            xmppdomain = ejabberd.domain;
          };
          database = {
            type = "postgresql";
            createLocally = true;
          };
          h2o = { };
        };

        services.ejabberd = {
          inherit (ejabberd) spoolDir;
          enable = true;
          configFile = ejabberd_config_file;
          imagemagick = false;
        };

        services.h2o.settings = {
          compress = "ON";
        };

        systemd.services.ejabberd = {
          serviceConfig = {
            # Certain misconfigurations can cause RAM usage to swell before
            # crashing; fail sooner with more-than-liberal memory limits
            StartupMemoryMax = "1G";
            MemoryMax = "512M";
          };
        };

        networking = {
          firewall.allowedTCPPorts = with ejabberd.ports; [
            c2s
            s2s
          ];
          extraHosts = ''
            127.0.0.1 ${movim.domain}
            127.0.0.1 ${ejabberd.domain}
          '';
        };
      };
  };

  testScript = # python
    ''
      ejabberdctl = "su ejabberd -s $(which ejabberdctl) "

      server.wait_for_unit("phpfpm-movim.service")
      server.wait_for_unit("h2o.service")
      server.wait_for_open_port(${builtins.toString movim.port})
      server.wait_for_open_port(80)

      server.wait_for_unit("ejabberd.service")
      ejabberd_status = server.succeed(ejabberdctl + "status")
      assert "status: started" in ejabberd_status
      server.succeed(ejabberdctl + "register ${ejabberd.admin.username} ${ejabberd.domain} ${ejabberd.admin.password}")

      server.wait_for_unit("movim.service")

      # Test unauthenticated
      server.fail("curl -L --fail-with-body --max-redirs 0 http://${movim.domain}/chat")

      # Test basic Websocket
      server.succeed("echo | websocat --origin 'http://${movim.domain}' 'ws://${movim.domain}/ws/?path=login&offset=0'")

      # Test login + create cookiejar
      login_html = server.succeed("curl --fail-with-body -c /tmp/cookies http://${movim.domain}/login")
      assert "${movim.description}" in login_html
      assert "${movim.info}" in login_html

      # Test authentication POST
      server.succeed("curl --fail-with-body -b /tmp/cookies -X POST --data-urlencode 'username=${ejabberd.admin.JID}' --data-urlencode 'password=${ejabberd.admin.password}' http://${movim.domain}/login")

      server.succeed("curl -L --fail-with-body --max-redirs 1 -b /tmp/cookies http://${movim.domain}/chat")
    '';
}
