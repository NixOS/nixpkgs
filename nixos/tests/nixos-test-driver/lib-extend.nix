{ pkgs, ... }:

let
  patchedPkgs = pkgs.extend (new: old: {
    lib = old.lib.extend (self: super: {
      sorry_dave = "sorry dave";
    });
  });

  testBody = {
    name = "demo lib overlay";

    nodes = {
      machine = { lib, ... }: {
        environment.etc."got-lib-overlay".text = lib.sorry_dave;
      };
    };

    # We don't need to run an actual test. Instead we build the `machine` configuration
    # and call it a day, because that already proves that `lib` is wired up correctly.
    # See the attrset returned at the bottom of this file.
    testScript = "";
  };

  inherit (patchedPkgs.testers) nixosTest runNixOSTest;
  evaluationNixosTest = nixosTest testBody;
  evaluationRunNixOSTest = runNixOSTest testBody;
in {
  nixosTest = evaluationNixosTest.driver.nodes.machine.system.build.toplevel;
  runNixOSTest = evaluationRunNixOSTest.driver.nodes.machine.system.build.toplevel;
}
