{ pkgs, lib, ... }:
let

  customSettings = {
    pageInfo = {
      title = "My Custom Dashy Title";
    };

    sections = [
      {
        name = "My Section";
        items = [
          {
            name = "NixOS";
            url = "https://nixos.org";
          }
        ];
      }
    ];
  };

  customSettingsYaml = (pkgs.formats.yaml_1_1 { }).generate "custom-conf.yaml" customSettings;
in
{
  name = "dashy";
  meta.maintainers = [ lib.maintainers.therealgramdalf ];

  defaults =
    { config, ... }:
    {
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "dashy.local";
        };
      };

      networking.extraHosts = "127.0.0.1 dashy.local";

      services.nginx.virtualHosts."${config.services.dashy.virtualHost.domain}".listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];
    };
  nodes = {
    machine = { };

    machine-custom = {
      services.dashy.settings = customSettings;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    actual = machine.succeed("curl -v --stderr - http://dashy.local/", timeout=10)
    expected = "<title>Dashy</title>"
    assert expected in actual, \
      f"unexpected reply from Dashy, expected: '{expected}' got: '{actual}'"

    machine_custom.wait_for_unit("nginx.service")
    machine_custom.wait_for_open_port(80)

    actual_custom = machine_custom.succeed("curl -s --stderr - http://dashy.local/conf.yml", timeout=10).strip()
    expected_custom = machine_custom.succeed("cat ${customSettingsYaml}").strip()

    assert expected_custom == actual_custom, \
      f"unexpected reply from Dashy, expected: '{expected_custom}' got: '{actual_custom}'"
  '';
}
