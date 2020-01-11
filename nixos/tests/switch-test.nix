# Test configuration switching.

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "switch-test";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = {
    machine = { ... }: {
      users.mutableUsers = false;
    };
    other = { ... }: {
      users.mutableUsers = true;
    };
  };

  testScript = {nodes, ...}: let
    originalSystem = nodes.machine.config.system.build.toplevel;
    otherSystem = nodes.other.config.system.build.toplevel;

    # Ensures failures pass through using pipefail, otherwise failing to
    # switch-to-configuration is hidden by the success of `tee`.
    stderrRunner = pkgs.writeScript "stderr-runner" ''
      #! ${pkgs.stdenv.shell}
      set -e
      set -o pipefail
      exec env -i "$@" | tee /dev/stderr
    '';
  in ''
    machine.succeed(
        "${stderrRunner} ${originalSystem}/bin/switch-to-configuration test"
    )
    machine.succeed(
        "${stderrRunner} ${otherSystem}/bin/switch-to-configuration test"
    )
  '';
})
