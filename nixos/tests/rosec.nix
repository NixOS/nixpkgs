{ pkgs, lib, ... }:
let
  rosec-config = pkgs.writeText "rosec-config.toml" ''
    [[provider]]
    id = "local"
    kind = "local"
    path = "/home/alice/.local/share/rosec/providers/local.vault"

    [[provider]]
    id = "gnome-keyring"
    kind = "gnome-keyring"

    [[provider]]
    id = "bitwarden-pm"
    kind = "bitwarden-pm"
    options = { email = "alice@example.com" }

    [[provider]]
    id = "bitwarden-sm"
    kind = "bitwarden-sm"
    options = { organization_id = "00000000-0000-0000-0000-000000000000" }
  '';

  wasm-providers = [
    pkgs.rosec-gnome-keyring-bin
    pkgs.rosec-bitwarden-pm-bin
    pkgs.rosec-bitwarden-sm-bin
  ];

  # Compile the system provider scan path (SYSTEM_PLUGIN_DIR) to a store path
  # with the WASM providers baked in, so discovery exercises the system path
  # rather than the per-user copy under ~/.local/share/rosec/providers.
  rosec-with-providers = pkgs.rosec.override { provider = wasm-providers; };
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
        package = rosec-with-providers;
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
      machine.succeed("su - alice -c 'mkdir -p ~/.config/rosec ~/.local/share/keyrings'")
      machine.succeed("su - alice -c 'cp ${config-path} ~/.config/rosec/config.toml'")
      machine.send_chars("alice\n")
      machine.wait_until_tty_matches("1", "login: alice")
      machine.wait_until_succeeds("pgrep login")
      machine.wait_until_tty_matches("1", "Password: ")
      machine.send_chars("${user.password}\n")
      machine.wait_until_succeeds("pgrep -u alice bash")

      machine.succeed("su - alice -c 'systemctl --user import-environment SSH_ASKPASS SSH_ASKPASS_REQUIRE'")

      with subtest("D-Bus activation starts rosecd and registers portal"):
          machine.succeed("su - alice -c 'secret-tool lookup application nonexistent-rosec-test >/dev/null 2>&1 || true'")
          _, output = machine.systemctl("status rosecd --no-pager", "alice")
          assert "Active: active (running)" in output
          machine.succeed("su - alice -c 'busctl --user list | grep -q org.freedesktop.impl.portal.desktop.rosec'")

      with subtest("WASM providers are discovered and loaded"):
          # Client-side discovery: re-runs the plugin scan and verifies each
          # minisig against the release keys embedded in the rosec binary.
          kinds = machine.succeed("su - alice -c 'rosec provider kinds'")
          for kind in ["gnome-keyring", "bitwarden-pm", "bitwarden-sm"]:
              assert kind in kinds, f"{kind} missing from 'rosec provider kinds'"

          # Daemon-side load: each configured provider registered with a live
          # state (not 'daemon not running').
          machine.wait_until_succeeds("su - alice -c 'systemctl --user is-active rosecd'")
          listing = machine.succeed("su - alice -c 'rosec provider list'")
          assert "daemon not running" not in listing
          for pid in ["gnome-keyring", "bitwarden-pm", "bitwarden-sm"]:
              assert pid in listing, f"provider {pid} missing from 'rosec provider list'"

          # rosecd journal confirms signature verification and discovery
          # through the compiled-in system path (source=System).
          machine.wait_until_succeeds(
              "su - alice -c 'journalctl --user -u rosecd | grep -q \"WASM plugin signature verified.*source=System\"'"
          )
          machine.succeed("su - alice -c 'journalctl --user -u rosecd | grep -q \"discovered WASM providers\"'")

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
