{ ... }:
let

  xrayUser = {
    # A random UUID.
    id = "a6a46834-2150-45f8-8364-0f6f6ab32384";
  };

  # 1080 [http proxy] -> 1081 [vless] -> direct
  xraysettings = {
    inbounds = [
      {
        tag = "http_in";
        port = 1080;
        listen = "127.0.0.1";
        protocol = "http";
      }
      {
        tag = "vless_in";
        port = 1081;
        listen = "127.0.0.1";
        protocol = "vless";
        settings.decryption = "none";
        settings.clients = [ xrayUser ];
      }
    ];
    outbounds = [
      {
        tag = "vless_out";
        protocol = "vless";
        settings.decryption = "none";
        settings.vnext = [
          {
            address = "127.0.0.1";
            port = 1081;
            users = [ (xrayUser // { encryption = "none"; }) ];
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
        outboundTag = "vless_out";
      }
      {
        type = "field";
        inboundTag = "vless_in";
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
  name = "xray";
  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
      services.xray = {
        enable = true;
        settings = xraysettings;
      };
      services.httpd = {
        enable = true;
        adminAddr = "foo@example.org";
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("httpd.service")
    machine.wait_for_unit("xray.service")
    machine.wait_for_open_port(80)
    machine.wait_for_open_port(1080)
    machine.succeed(
        "curl --fail --max-time 10 --proxy http://localhost:1080 http://localhost"
    )
  '';
}
