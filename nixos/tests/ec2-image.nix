# Run with:
#   cd nixpkgs
#   nix-build -A nixosTests.ec2-image

{
  config,
  lib,
  hostPkgs,
  ...
}:

let
  inherit (lib) mkAfter mkForce;
  pkgs = config.node.pkgs;

  # Build an EC2 image configuration
  imageCfg =
    (import ../lib/eval-config.nix {
      system = null;
      modules = [
        ../maintainers/scripts/ec2/amazon-image.nix
        ../modules/testing/test-instrumentation.nix
        ../modules/profiles/qemu-guest.nix
        {
          amazonImage.format = "qcow2";

          # In a NixOS test the serial console is occupied by the "backdoor"
          # (see testing/test-instrumentation.nix) and is incompatible with
          # the configuration in virtualisation/amazon-image.nix.
          systemd.services."serial-getty@ttyS0".enable = mkForce false;

          # Make /dev/console point to serial console for proper capture
          # test-instrumentation.nix adds console=tty0, so we need to add console=ttyS0 AFTER it
          # The last console= parameter takes precedence for /dev/console
          boot.kernelParams = mkAfter [ "console=ttyS0" ];

          # Configure VLAN networking to match test framework setup
          networking.interfaces.eth0 = {
            ipv4.addresses = [
              {
                address = config.nodes.machine.networking.primaryIPAddress;
                prefixLength = 24;
              }
            ];
          };

          nixpkgs.pkgs = pkgs;
        }
      ];
    }).config;

  image = "${imageCfg.system.build.amazonImage}/${imageCfg.image.fileName}";

in
{
  name = "ec2-image";
  meta = {
    maintainers = with lib.maintainers; [
      roberth
      arianvp
    ];
    timeout = 600;
  };
  nodes = {
    machine = { ... }: { }; # Dummy node for network config - won't be launched
    client =
      { ... }:
      {
        # Configure SSH client for non-interactive, strict authentication
        programs.ssh.extraConfig = ''
          Host *
            PasswordAuthentication no
            ChallengeResponseAuthentication no
            HostbasedAuthentication no
            BatchMode yes
            PubkeyAuthentication yes
            StrictHostKeyChecking yes
        '';
      };
  };

  testScript = ''
    import os
    import re
    import subprocess
    import tempfile

    # Instance Metadata Service (IMDSv2 with 1.0 metadata version)
    # TODO: Use 'latest' metadata version instead of '1.0'
    #       - Consider https://github.com/aws/amazon-ec2-metadata-mock
    #         - Blocked on https://github.com/aws/amazon-ec2-metadata-mock/issues/234
    #       - Consider https://github.com/purpleclay/imds-mock
    #       - [Test matrix] also test providing the host key through IMDS
    #         - i.e. a test module argument to select between writing or reading the host key
    def create_ec2_metadata_dir(temp_dir, client_pubkey):
        """Create fake EC2 metadata directory structure with mock data"""
        metadata_dir = os.path.join(temp_dir.name, "ec2-metadata")

        # Create directory structure
        os.makedirs(os.path.join(metadata_dir, "1.0", "meta-data", "public-keys", "0"), exist_ok=True)
        os.makedirs(os.path.join(metadata_dir, "latest", "api"), exist_ok=True)

        # Metadata version 1.0 endpoints (what fetch-ec2-metadata.sh actually fetches)
        with open(os.path.join(metadata_dir, "1.0", "meta-data", "hostname"), "w") as f:
            f.write("test-instance")
        with open(os.path.join(metadata_dir, "1.0", "meta-data", "ami-manifest-path"), "w") as f:
            f.write("(test)")
        with open(os.path.join(metadata_dir, "1.0", "meta-data", "instance-id"), "w") as f:
            f.write("i-1234567890abcdef0")
        with open(os.path.join(metadata_dir, "1.0", "user-data"), "w") as f:
            f.write("")
        with open(os.path.join(metadata_dir, "1.0", "meta-data", "public-keys", "0", "openssh-key"), "w") as f:
            f.write(client_pubkey)

        # IMDSv2 token endpoint - return a fake token
        with open(os.path.join(metadata_dir, "latest", "api", "token"), "w") as f:
            f.write("test-token-12345")

        return metadata_dir

    def generate_client_ssh_key():
        """Generate SSH key pair on VM host for client authentication"""
        # Use temporary directory for key generation
        import tempfile
        with tempfile.TemporaryDirectory() as key_dir:
            private_key = os.path.join(key_dir, "id_ed25519")
            public_key = os.path.join(key_dir, "id_ed25519.pub")

            # Generate key pair using host SSH tools
            ret = os.system(f"${hostPkgs.openssh}/bin/ssh-keygen -t ed25519 -f {private_key} -N \"\"")
            if ret != 0:
                raise Exception("Failed to generate SSH key pair")

            # Read the generated public key
            with open(public_key, "r") as f:
                client_pubkey = f.read().strip()

            # Read the private key
            with open(private_key, "r") as f:
                client_private_key = f.read()

            return client_pubkey, client_private_key

    def setup_client_ssh_key(client, client_private_key):
        """Install the pre-generated SSH private key on client"""
        client.succeed("mkdir -p /root/.ssh")
        client.succeed(f"cat > /root/.ssh/id_ed25519 << 'EOF'\n{client_private_key}\nEOF")
        client.succeed("chmod 600 /root/.ssh/id_ed25519")

    def setup_machine(temp_dir, client_pubkey):
        """Initialize EC2 machine with disk image, metadata server, and networking"""
        # Set up disk image
        image_dir = os.path.join(
            os.environ.get("TMPDIR", tempfile.gettempdir()), "tmp", "vm-state-machine"
        )
        os.makedirs(image_dir, mode=0o700, exist_ok=True)
        disk_image = os.path.join(image_dir, "machine.qcow2")
        subprocess.check_call([
            "qemu-img", "create", "-f", "qcow2", "-F", "qcow2",
            "-o", "backing_file=${image}", disk_image
        ])
        subprocess.check_call(["qemu-img", "resize", disk_image, "10G"])

        # Create fake EC2 metadata in temporary directory with client's public key
        metadata_dir = create_ec2_metadata_dir(temp_dir, client_pubkey)

        # Add both VLAN networking (matching test framework) and EC2 metadata server
        vlan_net = (
            " -device virtio-net-pci,netdev=vlan1,mac=52:54:00:12:01:02"
            + ' -netdev vde,id=vlan1,sock="$QEMU_VDE_SOCKET_1"'
        )
        metadata_net = (
            " -device virtio-net-pci,netdev=ec2meta"
            + f" -netdev 'user,id=ec2meta,net=169.0.0.0/8,guestfwd=tcp:169.254.169.254:80-cmd:${pkgs.micro-httpd}/bin/micro_httpd {metadata_dir}'"
        )

        start_command = (
            "qemu-kvm -m 1024"
            + f" -drive file={disk_image},if=virtio,werror=report"
            + vlan_net
            + metadata_net
            + " $QEMU_OPTS"
        )

        return create_machine(start_command)

    # Create temporary directory for metadata (scoped for cleanup)
    temp_dir = tempfile.TemporaryDirectory()

    # Start client first (but don't wait for it to boot)
    client.start()

    # Generate SSH key pair on VM host before starting machine
    client_pubkey, client_private_key = generate_client_ssh_key()

    # Set up machine with client's public key in metadata service
    machine = setup_machine(temp_dir, client_pubkey)

    try:
        machine.start()

        # Wait for services to be ready
        machine.wait_for_unit("sshd.service")
        machine.wait_for_unit("print-host-key.service")
        machine.wait_for_unit("apply-ec2-data.service")

        # Extract shared variables outside subtests
        machine_ip = "${config.nodes.machine.networking.primaryIPAddress}"

        with subtest("EC2 metadata service connectivity"):
            hostname_response = machine.succeed("curl --fail -s http://169.254.169.254/1.0/meta-data/hostname")
            assert "test-instance" in hostname_response, f"Expected 'test-instance', got: {hostname_response}"

        with subtest("SSH host key extraction from console"):
            console_log = machine.get_console_log()
            assert "-----BEGIN SSH HOST KEY FINGERPRINTS-----" in console_log
            assert "-----END SSH HOST KEY FINGERPRINTS-----" in console_log
            assert "-----BEGIN SSH HOST KEY KEYS-----" in console_log
            assert "-----END SSH HOST KEY KEYS-----" in console_log

            keys_pattern = r"-----BEGIN SSH HOST KEY KEYS-----(.*?)-----END SSH HOST KEY KEYS-----"
            keys_match = re.search(keys_pattern, console_log, re.DOTALL)
            assert keys_match, "Could not find SSH host keys section"
            keys_content = keys_match.group(1).strip()
            assert "ssh-" in keys_content, "SSH keys should contain ssh- prefix"

        with subtest("Network connectivity"):
            client.succeed(f"ping -c 1 {machine_ip}")

        with subtest("SSH connectivity with strict host key checking"):
            # Install the pre-generated private key on client
            setup_client_ssh_key(client, client_private_key)

            # Get console log and extract host keys
            console_log = machine.get_console_log()
            keys_pattern = r"-----BEGIN SSH HOST KEY KEYS-----(.*?)-----END SSH HOST KEY KEYS-----"
            keys_match = re.search(keys_pattern, console_log, re.DOTALL)
            assert keys_match, "Could not find SSH host keys section"

            # Create known_hosts file from console-extracted host keys
            keys_content = keys_match.group(1).strip()
            known_hosts_entries = []
            for line in keys_content.split('\n'):
                if line.strip() and line.startswith('ssh-'):
                    known_hosts_entries.append(f"{machine_ip} {line.strip()}")

            assert known_hosts_entries, "No SSH host keys found for known_hosts generation"

            known_hosts_content = '\n'.join(known_hosts_entries)
            client.succeed(f"cat > /root/.ssh/known_hosts << 'EOF'\n{known_hosts_content}\nEOF")

            # Test SSH connectivity with strict host key checking
            ssh_result = client.succeed(f"ssh -o ConnectTimeout=60 -o BatchMode=yes -i /root/.ssh/id_ed25519 root@{machine_ip} 'echo Hello from $(hostname)'")
            assert "Hello from test-instance" in ssh_result, f"Unexpected SSH result: {ssh_result}"

        with subtest("Basic EC2 functionality"):
            machine.succeed("findmnt / -o SIZE -n | grep -E '[0-9]+G'")

    finally:
        machine.shutdown()
        temp_dir.cleanup()
  '';
}
