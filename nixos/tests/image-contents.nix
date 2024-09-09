# Tests the contents attribute of nixos/lib/make-disk-image.nix
# including its user, group, and mode attributes.
{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  config = (import ../lib/eval-config.nix {
    inherit system;
    modules = [
      ../modules/testing/test-instrumentation.nix
      ../modules/profiles/qemu-guest.nix
      {
        fileSystems."/".device = "/dev/disk/by-label/nixos";
        boot.loader.grub.device = "/dev/vda";
        boot.loader.timeout = 0;
      }
    ];
  }).config;
  image = (import ../lib/make-disk-image.nix {
    inherit pkgs config;
    lib = pkgs.lib;
    format = "qcow2";
    contents = [
      {
        source = pkgs.writeText "testFile" "contents";
        target = "/testFile";
        user = "1234";
        group = "5678";
        mode = "755";
      }
      {
        source = ./.;
        target = "/testDir";
      }
    ];
  }) + "/nixos.qcow2";

in makeEc2Test {
  name = "image-contents";
  inherit image;
  userData = null;
  script = ''
    machine.start()
    # Test that if contents includes a file, it is copied to the target.
    assert "content" in machine.succeed("cat /testFile")
    fileDetails = machine.succeed("ls -l /testFile")
    assert "1234" in fileDetails
    assert "5678" in fileDetails
    assert "rwxr-xr-x" in fileDetails

    # Test that if contents includes a directory, it is copied to the target.
    dirList = machine.succeed("ls /testDir")
    assert "image-contents.nix" in dirList
  '';
}
