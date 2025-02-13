import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let

    v2rayUser = {
      # A random UUID.
      id = "a6a46834-2150-45f8-8364-0f6f6ab32384";
      alterId = 0; # Non-zero support will be disabled in the future.
    };

    # 1080 [http proxy] -> 1081 [vmess] -> direct
    v2rayConfig = {
      inbounds = [
        {
          tag = "http_in";
          port = 1080;
          listen = "127.0.0.1";
          protocol = "http";
        }
        {
          tag = "vmess_in";
          port = 1081;
          listen = "127.0.0.1";
          protocol = "vmess";
          settings.clients = [ v2rayUser ];
        }
      ];
      outbounds = [
        {
          tag = "vmess_out";
          protocol = "vmess";
          settings.vnext = [
            {
              address = "127.0.0.1";
              port = 1081;
              users = [ v2rayUser ];
            }
          ];
        }
        {
          tag = "direct";
          protocol = "freedom";
        }
      ];
      routing.rules = [
        {
          type = "field";
          inboundTag = "http_in";
          outboundTag = "vmess_out";
        }
        {
          type = "field";
          inboundTag = "vmess_in";
          outboundTag = "direct";
        }

        # Assert assets "geoip" and "geosite" are accessible.
        {
          type = "field";
          ip = [ "geoip:private" ];
          domain = [ "geosite:category-ads" ];
          outboundTag = "direct";
        }
      ];
    };

  in
  {
    name = "v2ray";
    meta = with lib.maintainers; {
      maintainers = [ servalcatty ];
    };
    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
        services.v2ray = {
          enable = true;
          config = v2rayConfig;
        };
        services.httpd = {
          enable = true;
          adminAddr = "foo@example.org";
        };
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("httpd.service")
      machine.wait_for_unit("v2ray.service")
      machine.wait_for_open_port(80)
      machine.wait_for_open_port(1080)
      machine.succeed(
          "curl --fail --max-time 10 --proxy http://localhost:1080 http://localhost"
      )
    '';
  }
)
