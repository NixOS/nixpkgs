{ pkgs, lib, ... }: {
  name = "aaaaxy";
  meta.maintainers = with lib.maintainers; [ Luflosi ];

  nodes.machine = {
    imports = [
      ./common/x11.nix
    ];
  };

  # This starts the game from a known state, feeds it a prerecorded set of button presses
  # and then checks if the final game state is identical to the expected state.
  # This is also what AAAAXY's CI system does and serves as a good sanity check.
  testScript = ''
    machine.wait_for_x()

    machine.succeed(
      # benchmark.dem needs to be in a mutable directory,
      # so we can't just refer to the file in the Nix store directly
      "mkdir -p '/tmp/aaaaxy/assets/demos/'",
      "ln -s '${pkgs.aaaaxy.testing_infra}/assets/demos/benchmark.dem' '/tmp/aaaaxy/assets/demos/'",
      """
        '${pkgs.aaaaxy.testing_infra}/scripts/regression-test-demo.sh' \
        'aaaaxy' 'on track for Any%, All Paths, No Teleports and No Coil' \
        '${pkgs.aaaaxy}/bin/aaaaxy' '/tmp/aaaaxy/assets/demos/benchmark.dem'
      """,
    )
  '';
}
