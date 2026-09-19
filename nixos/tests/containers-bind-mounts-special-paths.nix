{ lib, pkgs, ... }:
{
  name = "containers-bind-mounts-special-paths";
  meta.maintainers = [ ];

  nodes.machine = {
    containers.test-special-paths = {
      autoStart = true;
      bindMounts = {
        # Test single space
        "/mnt/single-space" = {
          hostPath = "/tmp/test-bind-mounts/path with spaces";
          isReadOnly = true;
        };
        # Test multiple consecutive spaces
        "/mnt/double-space" = {
          hostPath = "/tmp/test-bind-mounts/path  with  double";
          isReadOnly = true;
        };
        # Test space at beginning
        "/mnt/leading-space" = {
          hostPath = "/tmp/test-bind-mounts/ leading-space";
          isReadOnly = true;
        };
        # Test space at end
        "/mnt/trailing-space" = {
          hostPath = "/tmp/test-bind-mounts/trailing-space ";
          isReadOnly = true;
        };
        # Test path without spaces (control)
        "/mnt/no-spaces" = {
          hostPath = "/tmp/test-bind-mounts/no-spaces";
          isReadOnly = true;
        };
      };
      config = { };
    };

    # Create the test directories during system activation
    system.activationScripts.testBindMountPaths = ''
      mkdir -p "/tmp/test-bind-mounts/path with spaces"
      mkdir -p "/tmp/test-bind-mounts/path  with  double"
      mkdir -p "/tmp/test-bind-mounts/ leading-space"
      mkdir -p "/tmp/test-bind-mounts/trailing-space "
      mkdir -p "/tmp/test-bind-mounts/no-spaces"

      echo "single-space" > "/tmp/test-bind-mounts/path with spaces/test.txt"
      echo "double-space" > "/tmp/test-bind-mounts/path  with  double/test.txt"
      echo "leading-space" > "/tmp/test-bind-mounts/ leading-space/test.txt"
      echo "trailing-space" > "/tmp/test-bind-mounts/trailing-space /test.txt"
      echo "no-spaces" > "/tmp/test-bind-mounts/no-spaces/test.txt"
    '';
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.wait_for_unit("container@test-special-paths.service")

    with subtest("Container started successfully"):
        assert "test-special-paths" in machine.succeed("nixos-container list")
        assert "up" in machine.succeed("nixos-container status test-special-paths")

    with subtest("Verify no systemd warnings about invalid paths"):
        # Check that systemd didn't complain about paths not being absolute
        journal = machine.succeed("journalctl -u 'container@test-special-paths.service' --no-pager")
        assert "path is not absolute" not in journal, f"Found path warning in journal: {journal}"

    with subtest("Verify all bind mounts are accessible"):
        # Test single space
        output = machine.succeed("nixos-container run test-special-paths -- cat /mnt/single-space/test.txt")
        assert "single-space" in output, f"Expected 'single-space', got: {output}"

        # Test double spaces
        output = machine.succeed("nixos-container run test-special-paths -- cat /mnt/double-space/test.txt")
        assert "double-space" in output, f"Expected 'double-space', got: {output}"

        # Test leading space
        output = machine.succeed("nixos-container run test-special-paths -- cat /mnt/leading-space/test.txt")
        assert "leading-space" in output, f"Expected 'leading-space', got: {output}"

        # Test trailing space
        output = machine.succeed("nixos-container run test-special-paths -- cat /mnt/trailing-space/test.txt")
        assert "trailing-space" in output, f"Expected 'trailing-space', got: {output}"

        # Test control (no spaces)
        output = machine.succeed("nixos-container run test-special-paths -- cat /mnt/no-spaces/test.txt")
        assert "no-spaces" in output, f"Expected 'no-spaces', got: {output}"

    with subtest("Verify bind mounts are read-only"):
        # Attempting to write should fail
        machine.fail("nixos-container run test-special-paths -- touch /mnt/single-space/write-test.txt")
        machine.fail("nixos-container run test-special-paths -- touch /mnt/double-space/write-test.txt")

    with subtest("Verify mount information is correct"):
        # Check that mounts show the correct source paths with spaces
        mounts = machine.succeed("nixos-container run test-special-paths -- findmnt /mnt/single-space")
        assert "path with spaces" in mounts, f"Expected 'path with spaces' in mount info: {mounts}"

        mounts = machine.succeed("nixos-container run test-special-paths -- findmnt /mnt/double-space")
        assert "path  with  double" in mounts, f"Expected 'path  with  double' in mount info: {mounts}"
  '';
}
