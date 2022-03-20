import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd-initrd-simple";

  machine = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("basic.target")
  '';
})
