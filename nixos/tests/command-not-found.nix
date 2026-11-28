{
  name = "command-not-found";

  containers.machine =
    { lib, config, ... }:
    {
      assertions = [
        {
          assertion = config.programs.command-not-found.enable;
          message = "command-not-found should be enabled when the database file is present.";
        }
      ];
      programs.command-not-found.dbPath = lib.toFile "fake-db" "";
    };

  containers.machineWithoutCommandNotFound = { config, ... }: {
    assertions = [
      {
        assertion = !config.programs.command-not-found.enable;
        message = "command-not-found should be disabled when the database file is not present.";
      }
    ];
    # Explicitely set a path that doesn't exist to test, in case hydra writes the programs database which will fail this test.
    programs.command-not-found.dbPath = "/path/that/surely/doesnt/exist";
  };

  containers.machineMinimalProfile =
    {
      lib,
      modulesPath,
      config,
      ...
    }:
    {
      assertions = [
        {
          assertion = !config.programs.command-not-found.enable;
          message = "command-not-found should not conflict with minimal profile's definition.";
        }
      ];
      imports = [ (modulesPath + "/profiles/minimal.nix") ];
      programs.command-not-found.dbPath = lib.toFile "fake-db" "";
    };

  testScript = /* python */ ''
    machine.start()
    stdout = machine.fail("command-not-found 2>&1 this-command-doesnt-exist")
    assert "this-command-doesnt-exist: command not found" in stdout
  '';
}
