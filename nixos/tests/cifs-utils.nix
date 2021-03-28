import ./make-test-python.nix ({ pkgs, ... }: {
  name = "cifs-utils";

  machine = { pkgs, ... }: { environment.systemPackages = [ pkgs.cifs-utils ]; };

  testScript = ''
    machine.succeed("smbinfo -h")
    machine.succeed("smb2-quota -h")
    assert "${pkgs.cifs-utils.version}" in machine.succeed("cifs.upcall -v")
    assert "${pkgs.cifs-utils.version}" in machine.succeed("mount.cifs -V")
  '';
})
