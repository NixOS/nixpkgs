{
  name = "nixos-rebuild-switch";

  nodes = {
    machine =
      let
        configFile = ./configuration-to-switch-to.nix;
      in
      { modulesPath, ... }:
      {
        imports = [
          "${modulesPath}/installer/cd-dvd/channel.nix"
        ];

        system.includeBuildDependencies = true;

        system.rebuild.enableNg = false;

        virtualisation = {
          cores = 2;
          memorySize = 2048;
        };

        # Normally, nixos-rebuild will try to download any missing dependencies
        # from the Internet. Normally, NixOS tests can’t access the Internet.
        # This next part ensures that all the dependencies for building the
        # configurations that we’ll be switching to are already in the VM’s Nix
        # store so that the VM won’t need to access the Internet.
        specialisation.configurationToSwitchTo.configuration.imports = [ configFile ];

        environment.etc."configuration-to-switch-to.nix".source = configFile;
      };
  };

  testScript = ''
    from shlex import quote


    def create_generation_txt(gen):
        machine.succeed(f"echo {quote(gen)} > /etc/nixos/generation.txt")


    def test_for_boot_generation(gen):
        machine.succeed(f"""[ "$(nixos-rebuild list-generations --json | jq 'map(select(.current))[0].generation')" -eq {quote(gen)} ]""")


    def test_for_active_generation(gen):
        machine.succeed(f'[ "$(iAmGeneration)" -eq {quote(gen)} ]')


    machine.start()
    machine.succeed("nixos-generate-config")
    machine.succeed("cp /etc/configuration-to-switch-to.nix /etc/nixos/configuration.nix")

    with subtest("Does not have a system profile initially"):
        machine.fail("nixos-rebuild list-generations");

    with subtest("Create generation 1"):
        create_generation_txt("1")
        machine.succeed("nixos-rebuild switch")
        test_for_boot_generation("1")
        test_for_active_generation("1")

    with subtest("Create generation 2"):
        create_generation_txt("2")
        machine.succeed("nixos-rebuild switch")
        test_for_boot_generation("2")
        test_for_active_generation("2")

    with subtest("Create generation 3"):
        create_generation_txt("3")
        out = machine.succeed("nixos-rebuild switch 2>&1")
        assert "building the system configuration..." in out
        test_for_boot_generation("3")
        test_for_active_generation("3")

    with subtest("must switch to `--generation 1`"):
        create_generation_txt("4")
        out = machine.succeed("nixos-rebuild switch --generation 1 2>&1")
        assert "building the system configuration..." not in out
        test_for_boot_generation("1")
        test_for_active_generation("1")

    with subtest("`boot --generation 3` must not activate it"):
        machine.succeed("nixos-rebuild boot --generation 3")
        test_for_boot_generation("3")
        test_for_active_generation("1")
        # TODO: QEMU seems to have a tempfs and so after a reboot the content of the disk is lost
        # This also requires adding the parameter `machine.start(allow_reboot = True)`
        # machine.reboot()
        # test_for_active_generation("3")

    with subtest("`switch --rollback` must activate previous generation"):
        machine.succeed("nixos-rebuild switch --rollback")
        test_for_boot_generation("2")
        test_for_active_generation("2")
  '';
}
