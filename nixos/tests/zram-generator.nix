import ./make-test-python.nix {
  name = "zram-generator";

  nodes.machine = { pkgs, ... }: {
    environment.etc."systemd/zram-generator.conf".text = ''
      [zram0]
      zram-size = ram / 2
    '';
    systemd.packages = [ pkgs.zram-generator ];
    systemd.services."systemd-zram-setup@".path = [ pkgs.util-linux ]; # for mkswap
  };

  testScript = ''
    machine.wait_for_unit("systemd-zram-setup@zram0.service")
    assert "zram0" in machine.succeed("zramctl -n")
    assert "zram0" in machine.succeed("swapon --show --noheadings")
  '';
}
