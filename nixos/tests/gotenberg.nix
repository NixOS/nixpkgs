import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "gotenberg";
    meta.maintainers = with lib.maintainers; [ pyrox0 ];

    nodes.machine = {
      services.gotenberg = {
        enable = true;
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("gotenberg.service")

      # Gotenberg startup
      machine.wait_for_open_port(3000)

      # Ensure healthcheck endpoint succeeds
      machine.succeed("curl http://localhost:3000/health")
    '';
  }
)
