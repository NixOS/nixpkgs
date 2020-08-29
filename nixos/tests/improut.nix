import ./make-test-python.nix ({ lib, ... }: {
  name = "improut";
  meta.maintainers = with lib.maintainers; [ zopieux ];

  machine = { pkgs, lib, ... }: {
    services.improut = {
      enable = true;
      maxSize = 1234;
      defaultLifetime = 42;
      maxLifetime = 1337;
    };
  };

  testScript = ''
    machine.wait_for_unit("improut.service")
    machine.wait_for_open_port(8985)

    machine.succeed("curl -sSf localhost:8985/infos | grep -q 'max_file_size\":1234'")
    machine.succeed("curl -sSf localhost:8985/infos | grep -q 'max_delay\":1337'")
    machine.succeed("curl -sSf localhost:8985/infos | grep -q 'default_delay\":42'")
  '';
})
