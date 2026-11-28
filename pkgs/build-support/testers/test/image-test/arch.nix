{
  pkgs,
  ...
}:

# The flagship example: running NixOS-like tests over Arch Linux.
# The Arch Linux image is not built (yet?) by nixpkgs!

pkgs.testers.runImageTest {
  name = "arch-cloud";

  machines.machine = {
    image = pkgs.arch-cloud-image;
    cpus = 2;
    memory = "2G";
    # The first boot grows the filesystem and regenerates initramfs state.
    bootTimeout = 300;
  };

  globalTimeout = 900;

  testScript = ''
    out = await machine.succeed("grep '^ID=' /etc/os-release")
    assert "ID=arch" in out, out

    await machine.succeed("systemctl is-active sshd-vsock.socket")

    async with machine.subtest("file transfer round-trip"):
      await machine.copy_from_host("${./hello.txt}", "/tmp/hello.txt")
      content = await machine.succeed("cat /tmp/hello.txt")
      assert content.strip() == "hello from the host"
      await machine.copy_from_machine("/etc/os-release", "guests")
  '';
}
