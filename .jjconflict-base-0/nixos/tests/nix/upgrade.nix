{ pkgs, nixVersions, ... }:
let
  lib = pkgs.lib;

  fallback-paths-external = pkgs.writeTextDir "fallback-paths.nix" ''
    {
      ${pkgs.system} = "${nixVersions.latest}";
    }'';

  nixos-module = builtins.toFile "nixos-module.nix" ''
    { lib, pkgs, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/profiles/minimal.nix")
        (modulesPath + "/testing/test-instrumentation.nix")
      ];

      hardware.enableAllFirmware = lib.mkForce false;

      nix.settings.substituters = lib.mkForce [];
      nix.settings.hashed-mirrors = null;
      nix.settings.connect-timeout = 1;
      nix.extraOptions = "experimental-features = nix-command";

      environment.localBinInPath = true;
      users.users.alice = {
        isNormalUser = true;
        packages = [ pkgs.nixVersions.latest ];
      };
      documentation.enable = false;
    }
  '';
in

pkgs.testers.nixosTest {
  name = "nix-upgrade-${nixVersions.stable.version}-${nixVersions.latest.version}";
  meta.maintainers = with lib.maintainers; [ tomberek ];

  nodes.machine = {
    imports = [ nixos-module ];

    nix.package = nixVersions.stable;
    system.extraDependencies = [
      fallback-paths-external
    ];

    specialisation.newer-nix.configuration = {
      nix.package = lib.mkForce nixVersions.latest;

      users.users.alice.isNormalUser = true;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("nix-current"):
        # Create a profile to pretend we are on non-NixOS

        print(machine.succeed("nix --version"))
        print(machine.succeed("nix-env -i /run/current-system/sw/bin/nix -p /root/.local"))

    with subtest("nix-upgrade"):
        print(machine.succeed("nix upgrade-nix --nix-store-paths-url file://${fallback-paths-external}/fallback-paths.nix --profile /root/.local"))
        result = machine.succeed("nix --version")
        print(result)

        import re
        match = re.match(r".*${nixVersions.latest.version}$",result)
        if not match: raise Exception("Couldn't find new version in output: " + result)

    with subtest("nix-build-with-mismatch-daemon"):
        machine.succeed("runuser -u alice -- nix build --expr 'derivation {name =\"test\"; system = \"${pkgs.system}\";builder = \"/bin/sh\"; args = [\"-c\" \"echo test > $out\"];}' --print-out-paths")


    with subtest("remove-new-nix"):
        machine.succeed("rm -rf /root/.local")

        result = machine.succeed("nix --version")
        print(result)

        import re
        match = re.match(r".*${nixVersions.stable.version}$",result)

    with subtest("upgrade-via-switch-to-configuration"):
        # not using nixos-rebuild due to nix-instantiate being called and forcing all drv's to be rebuilt
        print(machine.succeed("/run/current-system/specialisation/newer-nix/bin/switch-to-configuration switch"))
        result = machine.succeed("nix --version")
        print(result)

        import re
        match = re.match(r".*${nixVersions.latest.version}$",result)
        if not match: raise Exception("Couldn't find new version in output: " + result)

    with subtest("nix-build-with-new-daemon"):
        machine.succeed("runuser -u alice -- nix build --expr 'derivation {name =\"test-new\"; system = \"${pkgs.system}\";builder = \"/bin/sh\"; args = [\"-c\" \"echo test > $out\"];}' --print-out-paths")

    with subtest("nix-collect-garbage-with-old-nix"):
        machine.succeed("${nixVersions.stable}/bin/nix-collect-garbage")
  '';
}
