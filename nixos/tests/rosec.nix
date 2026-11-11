{ pkgs, lib, ... }:
let
  rosec-config = pkgs.writeText "rosec-config.toml" ''
    [[provider]]
    id = "local"
    kind = "local"
    path = "/home/alice/.local/share/rosec/providers/local.vault"
  '';
in
{
  name = "rosec";
  meta.maintainers = [ lib.maintainers.mikilio ];
  # NOTE: PAM auto-unlock subtest requires interactive TTY login, which is
  # architecture-dependent on QEMU (serial device and GPU differ between x86
  # and aarch64). No existing test in nixpkgs handles this cross-platform.
  # The D-Bus activation and PAM config subtests are platform-agnostic.
  meta.broken = pkgs.stdenv.hostPlatform.isAarch64;

  nodes.machine =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    {
      imports = [ ./common/user-account.nix ];

      services.rosec = {
        enable = true;
        pam.enable = true;
      };

      environment.systemPackages = [ pkgs.libsecret ];

      environment.etc."rosec/test-askpass" = {
        text = ''
          #!/bin/sh
          echo "${user.password}"
        '';
        mode = "0755";
      };

      environment.variables = {
        SSH_ASKPASS = lib.mkForce "/etc/rosec/test-askpass";
        SSH_ASKPASS_REQUIRE = lib.mkForce "force";
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString user.uid}/bus";
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      config-path = "${rosec-config}";
    in
    ''
      machine.wait_until_tty_matches("1", "login: ")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "login: alice")
      machine.wait_until_succeeds("pgrep login")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("${user.password}\n")
      machine.wait_until_succeeds("pgrep -u alice bash")

      machine.succeed("su - alice -c 'mkdir -p ~/.config/rosec ~/.local/share/rosec/providers'")
      machine.succeed("su - alice -c 'cp ${config-path} ~/.config/rosec/config.toml'")
      machine.succeed("su - alice -c 'systemctl --user import-environment SSH_ASKPASS SSH_ASKPASS_REQUIRE'")

      with subtest("D-Bus activation starts rosecd and registers portal"):
          machine.succeed("su - alice -c 'secret-tool lookup application nonexistent-rosec-test >/dev/null 2>&1 || true'")
          _, output = machine.systemctl("status rosecd --no-pager", "alice")
          assert "Active: active (running)" in output
          machine.succeed("su - alice -c 'busctl --user list | grep -q org.freedesktop.impl.portal.desktop.rosec'")

      with subtest("PAM is configured with pam_rosec"):
          login_pam = machine.succeed("cat /etc/pam.d/login")

          import re
          assert any(re.match(r"auth\s+.*pam_rosec", l) for l in login_pam.splitlines()), "pam_rosec missing from auth stack"
          assert any(re.match(r"password\s+.*pam_rosec", l) for l in login_pam.splitlines()), "pam_rosec missing from password stack"
          assert any(re.match(r"session\s+.*pam_rosec", l) for l in login_pam.splitlines()), "pam_rosec missing from session stack"

      with subtest("PAM auto-unlocks the vault on login"):
          machine.succeed("su - alice -c 'echo ${user.password} | secret-tool store --label=PamTest application rosec-pam-test'")
          machine.succeed("su - alice -c 'rosec lock'")

          machine.send_chars("exit\n")
          machine.wait_until_fails("pgrep -u alice bash")
          machine.wait_until_tty_matches("1", "login: ")
          machine.send_chars("alice\n")
          machine.wait_until_tty_matches("1", "login: alice")
          machine.wait_until_succeeds("pgrep login")
          machine.wait_until_tty_matches("1", "Password: ")
          machine.send_chars("${user.password}\n")
          machine.wait_until_succeeds("pgrep -u alice bash")

          machine.wait_until_succeeds("su - alice -c 'systemctl --user is-active rosecd'", timeout=30)
          machine.succeed("su - alice -c 'timeout 30 bash -c \"until secret-tool lookup application rosec-pam-test >/dev/null 2>&1; do sleep 1; done\"'")
          result = machine.succeed("su - alice -c 'secret-tool lookup application rosec-pam-test'")
          assert "${user.password}" in result
    '';
}
