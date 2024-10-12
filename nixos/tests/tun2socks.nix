import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "tun2socks";
    meta.maintainers = with pkgs.lib.maintainers; [ kaleocheng ];

    nodes.machine =
      { ... }:
      {
        services.tun2socks = {
          enable = true;
          settings = {
            device = "tun0";
            proxy = "socks5://192.168.1.1";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("tun2socks.service")
    '';
  }
)
