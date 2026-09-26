{ config, lib, ... }:

{
  name = "dynacat";

  nodes = {
    machine_default =
      { ... }:
      {
        services.dynacat = {
          enable = true;
        };
      };

    machine_configured =
      { pkgs, ... }:
      let
        # Do not use this in production. This will make the secret world-readable
        # in the Nix store
        secrets.dynacat-location.path = toString (pkgs.writeText "location-secret" "Nivelles, Belgium");
      in
      {
        services.dynacat = {
          enable = true;
          settings = {
            server = {
              port = 5678;
              allow-editing = true;
            };
            pages = [
              {
                name = "Home";
                columns = [
                  {
                    size = "full";
                    widgets = [
                      { type = "calendar"; }
                      {
                        type = "weather";
                        location = {
                          _secret = secrets.dynacat-location.path;
                        };
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
  };

  extraPythonPackages =
    p: with p; [
      beautifulsoup4
      pyyaml
      types-pyyaml
      types-beautifulsoup4
    ];

  testScript = ''
    from bs4 import BeautifulSoup
    import yaml

    machine_default.start()
    machine_default.wait_for_unit("dynacat.service")
    machine_default.wait_for_open_port(8080)

    machine_configured.start()
    machine_configured.wait_for_unit("dynacat.service")
    machine_configured.wait_for_open_port(5678)

    with subtest("footer shows the packaged version"):
        soup = BeautifulSoup(machine_default.succeed("curl -sf http://localhost:8080"), "html.parser")
        expected_version = "${config.nodes.machine_default.services.dynacat.package.version}"
        assert any(a.text == expected_version for a in soup.select(".footer a"))

    with subtest("_secret values are substituted"):
        yaml_contents = machine_configured.succeed("cat /run/dynacat/dynacat.yml")
        yaml_parsed = yaml.load(yaml_contents, Loader=yaml.FullLoader)
        location = yaml_parsed["pages"][0]["columns"][0]["widgets"][1]["location"]
        assert location == "Nivelles, Belgium"

    with subtest("web UI editor is off by default"):
        machine_default.succeed(
            "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/editor/config | grep -x 403"
        )

    with subtest("web UI editor can be turned on"):
        machine_configured.succeed("curl -sf http://localhost:5678/api/editor/config")
  '';

  meta.maintainers = with lib.maintainers; [ andreszb ];
}
