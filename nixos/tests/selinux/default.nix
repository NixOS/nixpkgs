{ pkgs, lib, ... }:
let
  # Pin 33, supported by all Linux >= 5.7 kernels (including all NixOS
  # LTS kernels).
  policyVersion = 33;

  compiledPolicy = pkgs.runCommand "selinux-test-policy" { } ''
    mkdir -p "$out"
    ${lib.getExe pkgs.checkpolicy} -c ${toString policyVersion} -U allow \
      -o "$out/policy.${toString policyVersion}" ${./policy.conf}
    : > "$out/file_contexts"
  '';

  inherit (import ../ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;
in
{
  name = "selinux";
  meta.maintainers = with lib.maintainers; [ tomfitzhenry ];

  nodes.machine =
    { lib, ... }:
    {
      systemd.package = pkgs.systemd.override { withSelinux = true; };
      services.openssh = {
        enable = true;
        package = pkgs.openssh.override { withSelinux = true; };
        settings = {
          PasswordAuthentication = false;
          # Disable PAM so OpenSSH's built-in --with-selinux session transition
          # runs directly without requiring pam_selinux wiring.
          UsePAM = false;
        };
      };

      security.lsm = [ "selinux" ];
      boot.kernelParams = [ "enforcing=1" ];

      boot.initrd.systemd.contents = {
        "/etc/selinux/config".text = ''
          SELINUX=enforcing
          SELINUXTYPE=nixos-test
        '';
        "/etc/selinux/nixos-test/policy/policy.${toString policyVersion}".source =
          "${compiledPolicy}/policy.${toString policyVersion}";
        "/etc/selinux/nixos-test/contexts/files/file_contexts".source = "${compiledPolicy}/file_contexts";
      };

      environment.etc = {
        "selinux/config".text = ''
          SELINUX=enforcing
          SELINUXTYPE=nixos-test
        '';

        "selinux/nixos-test/policy/policy.${toString policyVersion}".source =
          "${compiledPolicy}/policy.${toString policyVersion}";

        "selinux/nixos-test/contexts/files/file_contexts".source = "${compiledPolicy}/file_contexts";

        "selinux/nixos-test/seusers".text = ''
          __default__:user_u
        '';

        "selinux/nixos-test/contexts/default_contexts".text = ''
          system_r:init_t	user_r:user_t
        '';
      };

      users.users.alice = {
        isNormalUser = true;
        # With UsePAM = false, sshd rejects accounts locked with "!" in /etc/shadow.
        hashedPassword = "*";
        openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
      };

      environment.systemPackages = [
        pkgs.libselinux
        pkgs.policycoreutils
      ];

      systemd.services.confined-allowed-read = {
        description = "Confined service reading an allowed SELinux type";
        serviceConfig = {
          Type = "oneshot";
          SELinuxContext = "system_u:system_r:confined_svc_t";
          ExecStart = pkgs.writeShellScript "confined-allowed-read" ''
            set -euo pipefail
            ctx="$(${pkgs.libselinux}/bin/getpidcon $$)"
            test "$ctx" = "system_u:system_r:confined_svc_t"
            content="$(cat /var/lib/selinux-test/allowed.txt)"
            test "$content" = "allowed-content"
          '';
        };
      };

      # Runs as root with no systemd sandboxing; only SELinux MAC
      # prevents it from reading the SSH host private key labeled secret_t.
      systemd.services.confined-secret-read = {
        description = "Confined root service attempting to read SSH host private key";
        serviceConfig = {
          Type = "oneshot";
          SELinuxContext = "system_u:system_r:confined_svc_t";
          ExecStart = pkgs.writeShellScript "confined-secret-read" ''
            set -euo pipefail
            test "$(id -u)" -eq 0
            cat /etc/ssh/ssh_host_ed25519_key
          '';
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("sshd.service")

    with subtest("SELinux policy loaded in stage-1 enforcing mode"):
        assert machine.succeed("getenforce").strip() == "Enforcing"
        assert machine.succeed("cat /sys/fs/selinux/enforce").strip() == "1"
        pid1_ctx = machine.succeed("getpidcon 1").strip()
        assert pid1_ctx == "system_u:system_r:init_t", f"unexpected PID 1 context: {pid1_ctx}"

    with subtest("xattr labeling"):
        machine.succeed("mkdir -p /var/lib/selinux-test")
        machine.succeed("printf 'allowed-content' > /var/lib/selinux-test/allowed.txt")
        machine.succeed("printf 'secret-content' > /var/lib/selinux-test/secret.txt")
        machine.succeed(
            "setfilecon system_u:object_r:allowed_t /var/lib/selinux-test/allowed.txt"
        )
        machine.succeed(
            "setfilecon system_u:object_r:secret_t /var/lib/selinux-test/secret.txt"
        )
        machine.succeed(
            "setfilecon system_u:object_r:secret_t /etc/ssh/ssh_host_ed25519_key"
        )
        label = machine.succeed("getfilecon /etc/ssh/ssh_host_ed25519_key").split()[-1]
        assert label == "system_u:object_r:secret_t", f"unexpected xattr label: {label}"

    with subtest("systemd SELinuxContext= blocks root from reading SSH host key"):
        machine.succeed("systemctl start confined-allowed-read.service")
        machine.fail("systemctl start confined-secret-read.service")

    with subtest("openssh with SELinux transitions login session to user_t"):
        machine.succeed("install -m 0600 ${snakeOilEd25519PrivateKey} /root/id_ed25519")
        ssh_opts = "-n -i /root/id_ed25519 -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
        ssh_ctx = machine.succeed(f"ssh {ssh_opts} alice@localhost 'getpidcon $$'").strip()
        assert ssh_ctx == "user_u:user_r:user_t", f"unexpected SSH session context: {ssh_ctx}"
        machine.fail(f"ssh {ssh_opts} alice@localhost cat /var/lib/selinux-test/secret.txt")
  '';
}
