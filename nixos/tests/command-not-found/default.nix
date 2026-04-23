{
  name = "command-not-found";

  nodes.machine =
    { lib, ... }:
    {
      programs.command-not-found = {
        dbPath = lib.mkForce (lib.toFile "fake-db" "");
      };
    };

  nodes.machineWithoutCommandNotFound = { };

  nodes.machineMinimalProfile =
    { lib, modulesPath, ... }:
    {
      imports = [ (modulesPath + "/profiles/minimal.nix") ];
      programs.command-not-found = {
        dbPath = lib.mkForce (lib.toFile "fake-db" "");
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.programs.command-not-found;
    in

    # Check auto-enable config priority.
    assert cfg.enable;
    assert !nodes.machineWithoutCommandNotFound.programs.command-not-found.enable;
    assert !nodes.machineMinimalProfile.programs.command-not-found.enable;

    /* python */ ''
      machine.start()
      stdout = machine.fail("command-not-found 2>&1 this-command-doesnt-exist")
      assert "this-command-doesnt-exist: command not found" in stdout
    '';
}
