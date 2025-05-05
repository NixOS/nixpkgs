{ lib, ... }:
{
  name = "homepage-dashboard";
  meta.maintainers = with lib.maintainers; [ jnsgruk ];

  nodes.machine = _: {
    services.homepage-dashboard = {
      enable = true;
      settings.title = "test title rodUsEagid"; # something random/unique
    };
  };

  testScript = ''
    # Ensure the services are started on managed machine
    machine.wait_for_unit("homepage-dashboard.service")
    machine.wait_for_open_port(8082)
    machine.succeed("curl --fail http://localhost:8082/")

    # Ensure /etc/homepage-dashboard is created.
    machine.succeed("test -d /etc/homepage-dashboard")

    # Ensure that we see the custom title *only in the managed config*
    page = machine.succeed("curl --fail http://localhost:8082/")
    assert "test title rodUsEagid" in page, "Custom title not found"
  '';
}
