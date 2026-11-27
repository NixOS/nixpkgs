{ runTest }:
let
  xrayUser.id = "a6a46834-2150-45f8-8364-0f6f6ab32384";

  # 1080 [http proxy] -> 1081 [vless] -> direct
  xraySettings = {
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
        # Traffic from vless_in may not reach loopback addresses by default.
        settings.finalRules = [
          {
            action = "allow";
            ip = [
              "127.0.0.0/8"
              "::1/128"
            ];
          }
        ];
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

  makeTest =
    name: xrayConfig:
    runTest {
      name = "xray-${name}";

      nodes.machine =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.curl ];
          services.xray = {
            enable = true;
          }
          // xrayConfig pkgs;
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
    };

  makeDumpTest =
    name: xrayConfig: expected:
    runTest {
      name = "xray-dump-${name}";
      nodes.machine =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.xray ];
          services.xray = {
            enable = true;
            package = pkgs.writeShellScriptBin "xray" ''
              exec ${pkgs.xray}/bin/xray "$@" -dump
            '';
          }
          // xrayConfig pkgs;

          systemd.services.xray.serviceConfig = {
            Type = "oneshot";
            StandardOutput = "file:/tmp/xray-output.json";
          };
        };

      testScript = ''
        import json

        def process_output(output, filter=False):
          loaded = json.loads(output)
          if filter:
            loaded = {k: loaded[k] for k in ('inbounds', 'outbounds', 'routing') if k in loaded}
          return json.dumps(loaded, sort_keys=True)

        start_all()
        machine.succeed("systemctl start xray.service")

        dumped = machine.succeed("cat /tmp/xray-output.json")
        expected_dumped = machine.succeed("cat ${expected} | xray run -dump")
        expected = machine.succeed("cat ${expected}")


        # xray adds default fields which makes comparing to the merged result problematic, comparing only inbounds, outbounds and routing
        assert process_output(dumped, True) == process_output(expected, True), f"Output mismatch!\nGot: {dumped}\nExpected: {expected}"

        # supplimentary: both files were parsed the same, xray will add identical default fields to both of them which makes it unnecessary to filter
        assert process_output(dumped) == process_output(expected_dumped), f"Output mismatch!\nGot: {dumped}\nExpected: {expected_dumped}"
      '';
    };
in
{
  settings = makeTest "settings" (_: {
    settings = xraySettings;
  });
  yaml = makeTest "yaml" (pkgs: {
    settingsFile = (pkgs.formats.yaml { }).generate "xray.yaml" xraySettings;
  });
  toml = makeTest "toml" (pkgs: {
    settingsFile = (pkgs.formats.toml { }).generate "xray.toml" xraySettings;
  });

  # Configurations copied verbatism from https://xtls.github.io/en/config/features/multiple.html#configuration-example
  dump = makeDumpTest "multiple-configs-dump" (_: {
    settings = { };
    extraSettingFiles = [
      ./files/01.json
      ./files/02.json
      ./files/03_tail.json
    ];
  }) ./files/expected.json;
}
