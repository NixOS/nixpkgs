import ./make-test-python.nix ({ pkgs, ... }:

let
  cryptHomeLuksPath = "/dev/mapper/alice-home-encrypted";
  pamMountConfPath = "/etc/security/pam_mount.conf.xml";
in
{
  name = "crypthomeluks";
  nodes = {
    machineWithCryptHomeLuks = { ... }:
    {
      users.users.alice = { isNormalUser = true; cryptHomeLuks = cryptHomeLuksPath; };
    };
    machineWithoutCryptHomeLuks = { ... }:
    {
      users.users.alice = { isNormalUser = true; };
    };
  };

  testScript = ''
      machineWithCryptHomeLuks.wait_for_unit("default.target")
      machineWithCryptHomeLuks.succeed("grep '<volume [^>]*path=\"${cryptHomeLuksPath}\"' ${pamMountConfPath}")
      machineWithoutCryptHomeLuks.wait_for_unit("default.target")
      machineWithoutCryptHomeLuks.fail("test -f ${pamMountConfPath}")
  '';
})
