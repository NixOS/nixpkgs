# Run with: nix-build -A nixosTests.nixos-test-driver.console-log
{
  name = "nixos-test-driver.console-log";

  nodes = {
    machine = {
      # Configure the machine to print some distinctive messages to console
      boot.kernelParams = [ "console=ttyS0,115200n8" ];

      # TODO: add a system service that logs to /dev/console, and test that
      #       blocked on https://github.com/NixOS/nixpkgs/issues/442382
    };
  };

  testScript = ''
    # Start the machine and wait for it to boot
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("get_console_log returns console output"):
      # Get the console log
      console_log = machine.get_console_log()
      # Verify it's a non-empty string
      assert isinstance(console_log, str), f"Expected string, got {type(console_log)}"
      assert len(console_log) > 0, "Console log should not be empty"

      print(f"Console log length: {len(console_log)} characters")
      print("Console log preview (first 500 chars):")
      print(console_log[:500])

    with subtest("console log contains boot messages"):
      # Check for typical boot messages
      assert "systemd" in console_log, "Console log should contain systemd messages"

      # Test direct stderr capture
      machine.succeed("echo 'DIRECT_TEST_MESSAGE_12345' >&2")
      import time
      time.sleep(1)

      updated_log = machine.get_console_log()
      assert "DIRECT_TEST_MESSAGE_12345" in updated_log, "Console log should capture stderr messages"
      print("Successfully captured stderr message in console log")

    with subtest("console log captures command output"):
      # Execute a command that prints to console via kernel messages
      machine.succeed("echo 'KERNEL_TEST_MESSAGE_12345' > /dev/kmsg")

      # Wait a moment for the message to be captured
      import time
      time.sleep(2)

      # Get updated console log
      updated_log = machine.get_console_log()
      if "KERNEL_TEST_MESSAGE_12345" in updated_log:
        print("Successfully captured kernel message in console log")
      else:
        print("Kernel message not found in console log - this may be expected depending on log level")

    with subtest("console log persists across multiple calls"):
      # Get console log twice and verify they're consistent
      log1 = machine.get_console_log()
      log2 = machine.get_console_log()

      # Both logs should contain the same content (log2 might have additional content)
      assert "systemd" in log1, "First log should contain systemd messages"
      assert "systemd" in log2, "Second log should contain systemd messages"
      assert len(log2) >= len(log1), "Second log should be at least as long as first log"
      assert "KERNEL_TEST_MESSAGE_12345" in log2, "Second log should contain our kernel test message"

    with subtest("console log contains kernel messages"):
      # Look for typical kernel boot messages
      kernel_indicators = ["Linux version", "Command line:", "Kernel command line"]
      kernel_found = any(indicator in console_log for indicator in kernel_indicators)
      assert kernel_found, f"Console log should contain kernel messages. Indicators checked: {kernel_indicators}"

    with subtest("console log is cleared on machine restart"):
      # Get the current console log and verify it contains our test messages
      pre_shutdown_log = machine.get_console_log()
      assert "KERNEL_TEST_MESSAGE_12345" in pre_shutdown_log, "Pre-shutdown log should contain our kernel test message"
      assert "DIRECT_TEST_MESSAGE_12345" in pre_shutdown_log, "Pre-shutdown log should contain our stderr test message"
      pre_shutdown_length = len(pre_shutdown_log)
      print(f"Pre-shutdown console log length: {pre_shutdown_length} characters")

      # Shutdown the machine
      machine.shutdown()

      # Start the machine again
      machine.start()
      machine.wait_for_unit("multi-user.target")

      # Get the console log after restart
      post_restart_log = machine.get_console_log()
      post_restart_length = len(post_restart_log)
      print(f"Post-restart console log length: {post_restart_length} characters")

      # Verify the old messages are gone (log should be fresh)
      assert "KERNEL_TEST_MESSAGE_12345" not in post_restart_log, "Post-restart log should not contain old kernel test message"
      assert "DIRECT_TEST_MESSAGE_12345" not in post_restart_log, "Post-restart log should not contain old stderr test message"

      # Verify we still have boot messages (log should contain new boot sequence)
      assert "systemd" in post_restart_log, "Post-restart log should contain systemd messages from new boot"
      kernel_found_restart = any(indicator in post_restart_log for indicator in kernel_indicators)
      assert kernel_found_restart, "Post-restart log should contain kernel messages from new boot"

      # Add a new test message to verify the log is working after restart
      machine.succeed("echo 'POST_RESTART_TEST_MESSAGE_67890' > /dev/kmsg")
      import time
      time.sleep(1)

      final_log = machine.get_console_log()
      assert "POST_RESTART_TEST_MESSAGE_67890" in final_log, "Should capture new messages after restart"

      print("Console log successfully cleared on restart and is functional again")

    print("All console log tests passed successfully!")
  '';
}
