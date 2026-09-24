{ hostPkgs, ... }:

{
  name = "pam-u2f";

  qemu.package = hostPkgs.qemu_test.override { u2fEmuSupport = true; };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.qemu.options = [
        "-usb"
        "-device u2f-emulated"
      ];

      security.pam.u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          debug = true;
          origin = "pam://nixos-test";
        };
      };

      users.users.alice = {
        isNormalUser = true;
        uid = 1000;
      };

      environment.systemPackages = with pkgs; [
        libfido2
        pam_u2f
      ];

      # Allow non-root users to access the virtual U2F device
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
      '';
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    # The virtual U2F device should be recognized
    machine.succeed("fido2-token -L | grep -q hidraw")

    # Register a U2F credential for alice
    machine.succeed("mkdir -p /home/alice/.config/Yubico")
    machine.succeed(
        "pamu2fcfg -u alice -o pam://nixos-test"
        " > /home/alice/.config/Yubico/u2f_keys"
    )
    machine.succeed("chown -R alice:users /home/alice/.config")

    # Log in as alice on tty2. With control=sufficient, pam_u2f runs
    # before pam_unix. The emulated device auto-approves user presence,
    # so alice is authenticated by her U2F key — no password needed.
    machine.send_key("alt-f2")
    machine.wait_until_succeeds("[ $(fgconsole) = 2 ]")
    machine.wait_for_unit("getty@tty2.service")
    machine.wait_until_tty_matches("2", "login: ")
    machine.send_chars("alice\n")

    # alice should get a shell without being asked for a password
    machine.wait_until_succeeds("pgrep -u alice bash")
    machine.send_chars("touch /tmp/u2f-login-success\n")
    machine.wait_for_file("/tmp/u2f-login-success")
  '';
}
