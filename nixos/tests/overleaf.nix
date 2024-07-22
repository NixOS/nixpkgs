import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "overleaf";
    meta.maintainers = with lib.maintainers; [
      camillemndn
      julienmalka
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.overleaf = {
          enable = true;
          secrets.WEB_API_PASSWORD = "/etc/overleaf/apipass";
        };

        environment.etc."overleaf/apipass".text = "mypassword";
      };

    enableOCR = true;

    testScript = ''
      machine.start()

      with subtest("Start Overleaf unit"):
        machine.wait_for_unit("overleaf-web.service")
        machine.wait_for_open_port(3032)
    '';
  }
)
