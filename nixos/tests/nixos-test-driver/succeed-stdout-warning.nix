# Run with:
#   cd nixpkgs
#   nix-build -A nixosTests.nixos-test-driver.succeed-stdout-warning
{
  name = "Test that succeed() warns when stdout stays open after command exits";

  nodes = {
    machine = (
      { pkgs, ... }:
      {
      }
    );
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    with subtest("Fast command should NOT produce warning"):
        machine.succeed("echo 'MARKER: before fast command' >&2")
        output = machine.succeed("echo HELLO")
        assert output == "HELLO\n", f"Expected 'HELLO\\n', got {output!r}"
        machine.succeed("echo 'MARKER: after fast command' >&2")

    with subtest("Background process keeps stdout open - should produce warning"):
        machine.succeed("echo 'MARKER: before slow command' >&2")
        output = machine.succeed("(echo ONE; sleep 15; echo TWO) &")
        assert output == "ONE\nTWO\n", f"Expected 'ONE\\nTWO\\n', got {output!r}"
        machine.succeed("echo 'MARKER: after slow command' >&2")

    with subtest("Exit status should be preserved (non-zero)"):
        try:
            machine.succeed("exit 42")
            assert False, "Expected command to fail with exit code 42"
        except Exception as e:
            # Verify the exception message contains the correct exit code
            assert "exit code 42" in str(e), f"Expected 'exit code 42' in exception, got: {e}"

    with subtest("User Command stderr should go to console"):
        machine.succeed("echo 'STDERR_TEST_MARKER: user command stderr output' >&2")

    # Fail the test so testBuildFailure can access the log
    raise Exception("Test script done and successful so far. Intentionally failing so that testBuildFailure can perform remaining log checks")
  '';
}
