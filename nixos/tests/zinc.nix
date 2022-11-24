import ./make-test-python.nix ({ pkgs, ... }: {
  name = "zinc";
  meta = { };

  nodes.machine =
    { pkgs, lib, ... }:

    {
      services.zinc = {
        enable = true;
        firstAdminPasswordFile = toString (pkgs.writeText "database-password" "correct horse battery staple");
      };
    };

  testScript = ''
    machine.wait_for_unit("zinc.service")
    machine.wait_for_open_port(4080)
    machine.succeed(
        "curl -sSf http://localhost:4080/metrics | grep 'zinc_request_size_bytes_sum'"
    )
  '';
})
