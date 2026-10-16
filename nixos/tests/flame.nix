{ lib, ... }:
{
  name = "flame";

  meta.maintainers = with lib.maintainers; [ DerGrumpf ];

  nodes.machine = {
    services.flame = {
      enable = true;
      passwordFile = "/etc/flame-password";

      apps = [
        {
          name = "Test App";
          url = "http://example.com";
        }
      ];

      categories = [
        {
          name = "Test Category";
          bookmarks = [
            {
              name = "Nixpkgs";
              url = "https://github.com/NixOS/nixpkgs";
            }
          ];
        }
      ];

      settings = {
        customTitle = "Test Flame";
        customUnknownKey = "test-value";
      };

      customCSS = ''
        body { background: #123456; }
      '';
    };

    systemd.tmpfiles.rules = [
      "f /etc/flame-password 0400 root root - testpassword"
    ];
  };

  testScript = ''
    machine.wait_for_unit("flame.service")
    machine.wait_for_open_port(5005)
    machine.succeed("curl -f http://localhost:5005/")

    machine.wait_for_unit("flame-seed.service")

    machine.succeed("curl -f http://localhost:5005/api/apps | grep -q 'Test App'")
    machine.succeed("curl -f http://localhost:5005/api/categories | grep -q 'Test Category'")
    machine.succeed("curl -f http://localhost:5005/api/categories | grep -q Nixpkgs")
    machine.succeed("curl -f http://localhost:5005/api/config | grep -q 'Test Flame'")
    machine.succeed("curl -f http://localhost:5005/flame.css | grep -q '#123456'")

    # Restart resilience
    machine.succeed("systemctl restart flame.service")
    machine.wait_for_unit("flame.service")
    machine.wait_for_open_port(5005)
    machine.succeed("curl -f http://localhost:5005/api/apps | grep -q 'Test App'")

    # Freeform settings pass-through (unknown key, not explicitly declared)
    machine.succeed("curl -f http://localhost:5005/api/config | grep -q customUnknownKey")
  '';
}
