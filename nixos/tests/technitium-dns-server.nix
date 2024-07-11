import ./make-test-python.nix ({pkgs, lib, ...}:
{
  name = "technitium-dns-server";

  nodes = {
    machine = {pkgs, ...}: {
      services.technitium-dns-server = {
        enable = true;
        openFirewall = true;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("technitium-dns-server.service")
    machine.wait_for_open_port(53)
  '';

  meta.maintainers = with lib.maintainers; [ fabianrig ];
})
