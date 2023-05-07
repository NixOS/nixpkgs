import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "baserow";

  meta = with lib.maintainers; {
    maintainers = [ raitobezarius julienmalka ];
  };

  nodes.machine = { ... }: {
    services.baserow = {
      enable = true;
      environment = {
        BASEROW_PUBLIC_URL = "http://localhost";
      };
      # Do not do this in production.
      secretFile = pkgs.writeText "secret" ''
      SECRET_KEY=aaaaaaaaaaaaaaaaaaaaaaaa
      '';
    };
  };

  testScript = { nodes }: ''
    machine.start()
    machine.wait_for_unit("baserow.target")
    machine.wait_for_open_port(8000)

    print(machine.succeed(
        "curl -H 'Host: localhost' -sSfL http://[::1]:8000/api/settings/"
    ))
    # [::1] is not an allowed host.
    machine.fail(
        "curl -sSfL http://[::1]:8000/api/settings/"
    )

  '';
})
