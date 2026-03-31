{ lib, ... }:
{
  name = "stc-template-dropin";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      # Define the base template. This file exists in both generations.
      systemd.services."test-template@" = {
        description = "A base template for testing";
        serviceConfig.ExecStart = "${pkgs.coreutils}/bin/sleep infinity";
      };

      # Define the managed instance using drop-ins.
      systemd.services."test-template@managed" = {
        overrideStrategy = "asDropin";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Environment = "TEST_VAR=1";
      };

      # Also define a service which will be changed
      systemd.services."test-template@changed" = {
        overrideStrategy = "asDropin";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Environment = "TEST_VAR=1";
      };

      # Create a new generation that explicitly removes the managed instance
      specialisation.new-generation.configuration = {
        systemd.services."test-template@managed" = {
          enable = lib.mkForce false;
          wantedBy = lib.mkForce [ ];
        };
        systemd.services."test-template@changed" = {
          serviceConfig.Environment = lib.mkForce "TEST_VAR=2";
        };
      };
    };

  testScript = # python
    ''
      managed_unit = "test-template@managed.service"
      changed_unit = "test-template@changed.service"
      manual_unit = "test-template@manual.service"

      with subtest("Start the machine and ensure the managed instance is running"):
          machine.wait_for_unit("multi-user.target")
          machine.wait_for_unit(managed_unit)
          machine.wait_for_unit(changed_unit)

      with subtest("Imperatively start an unmanaged instance"):
          machine.succeed(f"systemctl start {manual_unit}")
          machine.wait_for_unit(manual_unit)

      with subtest("Run dry-activate on the new generation"):
          new_gen = "/run/booted-system/specialisation/new-generation"

          # switch-to-configuration prints to stderr, so we redirect it to stdout for parsing
          output = machine.succeed(f"{new_gen}/bin/switch-to-configuration dry-activate 2>&1")
          machine.log("dry-activate output:\n" + output)

          found_stop = False
          found_start = False
          found_changed = False
          found_manual_stop = False
          for line in output.splitlines():
              if line.startswith("would stop"):
                  found_stop = managed_unit in line
                  found_manual_stop = manual_unit in line
              elif line.startswith("would start"):
                  found_start = managed_unit in line
                  found_changed = changed_unit in line

          assert found_stop, "The managed instance was not marked for stopping."
          assert found_changed, "The changed unit was not marked for stopping + starting (restarting)."
          assert not found_start, "switch-to-configuration wants to start the removed managed instance!"
          assert not found_manual_stop, "switch-to-configuration wants to stop the manual instance!"

      with subtest("Perform the actual switch and verify system state"):
          machine.succeed(f"{new_gen}/bin/switch-to-configuration switch")

          # The managed instance should be dead
          machine.fail(f"systemctl is-active {managed_unit}")

          # The changed instance should be running
          machine.succeed(f"systemctl is-active {changed_unit}")

          # The manual instance should survive the configuration switch untouched
          machine.succeed(f"systemctl is-active {manual_unit}")
    '';
}
