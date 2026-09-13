{ pkgs, runTest }:
let
  makeTestDump =
    name: extraSettingsFiles: expectedJson:
    runTest {
      name = "xray-dump-${name}";

      nodes.machine =
        { pkgs, ... }:
        {
          services.xray = {
            enable = true;
            inherit extraSettingsFiles;
            settings = { };
          };

          environment.etc."xray-expected.json".source = pkgs.writeText "xray-expected.json" expectedJson;
          services.xray.package = pkgs.writeShellScriptBin "xray" ''
            exec ${pkgs.xray}/bin/xray "$@" -dump
          '';
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
        expected_dumped = machine.succeed("cat /etc/xray-expected.json | ${pkgs.xray}/bin/xray run -dump")
        expected = machine.succeed("cat /etc/xray-expected.json")


        # xray adds default fields which makes comparing to the merged result problematic
        assert process_output(dumped, True) == process_output(expected, True), f"Output mismatch!\nGot: {dumped}\nExpected: {expected}"

        # supplimentary: both files were parsed the same, xray will add identical default fields to both of them which makes it unnecessary to filter
        assert process_output(dumped) == process_output(expected_dumped), f"Output mismatch!\nGot: {dumped}\nExpected: {expected_dumped}"
      '';
    };

in
{
  # verbatim from https://xtls.github.io/en/config/features/multiple.html
  multipleConfigs =
    makeTestDump "muiltiple-configs"
      [
        (builtins.toString (
          pkgs.writeText "01.json" ''
            {
              "log": {
                "loglevel": "warning"
              },
              "inbounds": [
                {
                  "tag": "socks",
                  "protocol": "socks",
                  "listen": "0.0.0.0",
                  "port": 8888
                }
              ],
              "outbounds": [
                {
                  "tag": "direct",
                  "protocol": "freedom"
                }
              ]
            }
          ''
        ))
        (builtins.toString (
          pkgs.writeText "02.json" ''
            {
              "log": {
                "loglevel": "debug"
              },
              "inbounds": [
                {
                  "tag": "socks",
                  "protocol": "socks",
                  "listen": "127.0.0.1",
                  "port": 1080
                }
              ],
              "outbounds": [
                {
                  "tag": "block",
                  "protocol": "blackhole"
                }
              ]
            }
          ''
        ))
        {
          path = (
            pkgs.writeText "03_tail.json" ''
              {
                "outbounds": [
                  {
                    "tag": "direct2",
                    "protocol": "freedom"
                  }
                ]
              }
            ''
          );
          tail = true;
        }
      ]
      ''
        {
          "log": {
            "loglevel": "debug"
          },
          "inbounds": [
            {
              "tag": "socks",
              "protocol": "socks",
              "listen": "127.0.0.1",
              "port": 1080
            }
          ],
          "outbounds": [
            {
              "tag": "block",
              "protocol": "blackhole"
            },
            {
              "tag": "direct",
              "protocol": "freedom"
            },
            {
              "tag": "direct2",
              "protocol": "freedom"
            }
          ]
        }
      '';
}
