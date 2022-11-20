import ../make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "gotosocial";
  meta.maintainers = with maintainers; [ pbsds ];

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ jq ];
    services.gotosocial = {
      enable = true;
      settings.port = 31337;
    };
  };

  testScript = ''
    machine.wait_for_unit("gotosocial.service")
    machine.wait_for_unit("postgres.service")
    machine.wait_for_open_port(31337)
    machine.succeed("curl http://localhost:31337/api/version")
  '';
})
