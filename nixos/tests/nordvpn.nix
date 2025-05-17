{ lib, ... }:
{
  name = "nordvpn";
  meta.maintainers = with lib.maintainers; [ sanferdsouza ];

  nodes = {
    basic =
      { ... }:
      {
        services.nordvpn.enable = true;
      };
  };

  testScript = ''
    basic.start()
    basic.wait_for_unit("nordvpnd", timeout=60)
    basic.succeed("nordvpn")

    # verify can talk to nordvpnd. give nordvpnd at most 5s to initialize.
    basic.wait_until_succeeds("nordvpn status", timeout=5)
    basic.succeed("nordvpn status")
  '';
}
