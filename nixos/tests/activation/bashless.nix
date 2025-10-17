# This is a smoke test that tests that basic functionality is still available
# with the bashless profile. For this, however, we have to re-enable bash.

{ lib, ... }:

{

  name = "activation-bashless";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { pkgs, modulesPath, ... }:
    {
      imports = [ "${modulesPath}/profiles/bashless.nix" ];

      # Forcibly re-set options that would normally be set by the bashless
      # profile but that we have to re-enable to make the test instrumentation
      # work.
      environment.binsh = lib.mkForce null;
      boot.initrd.systemd.shell.enable = false;

      # This ensures that we only have the store paths of our closure in the
      # in the guest. This is necessary so we can grep in the store.
      virtualisation.mountHostNixStore = false;
      virtualisation.useNixStoreImage = true;

      # Re-enable just enough of a normal NixOS system to be able to run tests
      programs.bash.enable = true;
      environment.shell.enable = true;
      environment.systemPackages = [
        pkgs.coreutils
        pkgs.gnugrep
      ];

      # Unset the regex because the tests instrumentation needs bash.
      system.forbiddenDependenciesRegexes = lib.mkForce [ ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("/bin/sh doesn't exist"):
      machine.fail("stat /bin/sh")

    bash_store_paths = machine.succeed("ls /nix/store | grep bash || true")
    print(bash_store_paths)
  '';

}
