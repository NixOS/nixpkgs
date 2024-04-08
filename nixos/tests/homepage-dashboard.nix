import ./make-test-python.nix ({ lib, ... }: {
  name = "homepage-dashboard";
  meta.maintainers = with lib.maintainers; [ jnsgruk ];

  nodes.unmanaged_conf = { pkgs, ... }: {
    services.homepage-dashboard.enable = true;
  };

  nodes.managed_conf = { pkgs, ... }: {
    services.homepage-dashboard = {
      enable = true;
      settings.title = "custom";
    };
  };

  testScript = ''
    # Ensure the services are started on unmanaged machine
    unmanaged_conf.wait_for_unit("homepage-dashboard.service")
    unmanaged_conf.wait_for_open_port(8082)
    unmanaged_conf.succeed("curl --fail http://localhost:8082/")

    # Ensure that /etc/homepage-dashboard doesn't exist, and boilerplate
    # configs are copied into place.
    unmanaged_conf.fail("test -d /etc/homepage-dashboard")
    unmanaged_conf.succeed("test -f /var/lib/private/homepage-dashboard/settings.yaml")

    # Ensure the services are started on managed machine
    managed_conf.wait_for_unit("homepage-dashboard.service")
    managed_conf.wait_for_open_port(8082)
    managed_conf.succeed("curl --fail http://localhost:8082/")

    # Ensure /etc/homepage-dashboard is created and unmanaged conf location isn't.
    managed_conf.succeed("test -d /etc/homepage-dashboard")
    managed_conf.fail("test -f /var/lib/private/homepage-dashboard/settings.yaml")
  '';
})
