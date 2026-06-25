import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "ssh-tpm-agent-virtual-machine";

    meta = {
      maintainers = [
        lib.maintainers.akechishiro
        lib.maintainers.arunoruto
      ];
    };

    nodes.machine =
      { ... }:
      {
        virtualisation = {
          # Provide a TPM to test vTPM
          tpm.enable = true;
        };
        services.ssh-tpm-agent.enable = true;
      };

    testScript = ''
      # Wait for the ssh tpm agent service has started
      machine.wait_for_unit("ssh-tpm-agent.service")

      # Test socket existence
      machine.succeed("ls /var/tmp/ssh-tpm-agent.sock")

      # Test if the keys are created by the ssh-tpm-genkeys service
      machine.succeed("ls /etc/ssh/ssh_tpm_host_ecdsa_key.tpm")
      machine.succeed("ls /etc/ssh/ssh_tpm_host_ecdsa_key.pub")

      machine.succeed("ls /etc/ssh/ssh_tpm_host_rsa_key.tpm")
      machine.succeed("ls /etc/ssh/ssh_tpm_host_rsa_key.pub")
    '';
  }
)
