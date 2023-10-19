# Test for https://github.com/NixOS/nixpkgs/pull/193469
import ./make-test-python.nix {
  name = "early-mount-options";

  nodes.machine = {
    virtualisation.fileSystems."/var" = {
      options = [ "bind" "nosuid" "nodev" "noexec" ];
      device = "/var";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    var_mount_info = machine.succeed("findmnt /var -n -o OPTIONS")
    options = var_mount_info.strip().split(",")
    assert "nosuid" in options and "nodev" in options and "noexec" in options
  '';
}
