import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "systemd-journal";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };

  machine = { pkgs, lib, ... }: {
    services.journald.enableHttpGateway = true;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    machine.succeed(
        "${pkgs.curl}/bin/curl -s localhost:19531/machine | ${pkgs.jq}/bin/jq -e '.hostname == \"machine\"'"
    )
  '';
})
