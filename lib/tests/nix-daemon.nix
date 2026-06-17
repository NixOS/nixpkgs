# to run these tests:
# nix-instantiate --eval --strict lib/tests/nix-daemon.nix
let
  lib = import ../default.nix;

  buildMachine1 = {
    hostName = "localhost";
    sshKey = "/home/groot/.ssh/id_rsa";
    system = "x86_64-linux";
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [
      "big-parallel"
      "kvm"
    ];
  };

  nixConfModule =
    { config, ... }:
    {
      buildMachine = buildMachine1;
    };

  finalConfig =
    (lib.modules.evalModules {
      modules = [
        nixConfModule
        (
          { config, ... }:
          {
            options = {
              buildMachine = lib.mkOption {
                description = lib.mdDoc ''PlaceHolder'';
                type = lib.types.submoduleWith {
                  modules = [ ../../nixos/modules/config/nix-remote-builder.nix ];
                  specialArgs = {
                    nixVersion = "2.32";
                  };
                };
              };
            };
          }
        )
      ];
    }).config;
in
lib.runTests {
  testNixRemoteBuilderUri = {
    expr = finalConfig.buildMachine.rendered;
    expected = "ssh://localhost x86_64-linux /home/groot/.ssh/id_rsa 2 2 big-parallel,kvm - -";
  };
}
