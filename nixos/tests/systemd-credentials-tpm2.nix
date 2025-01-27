import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "systemd-credentials-tpm2";

    meta = {
      maintainers = with pkgs.lib.maintainers; [ tmarkus ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        virtualisation.tpm.enable = true;
        environment.systemPackages = with pkgs; [ diffutils ];
      };

    testScript = ''
      CRED_NAME = "testkey"
      CRED_RAW_FILE = f"/root/{CRED_NAME}"
      CRED_FILE = f"/root/{CRED_NAME}.cred"

      def systemd_run(machine, cmd):
          machine.log(f"Executing command (via systemd-run): \"{cmd}\"")

          (status, out) = machine.execute( " ".join([
              "systemd-run",
              "--service-type=exec",
              "--quiet",
              "--wait",
              "-E PATH=\"$PATH\"",
              "-p StandardOutput=journal",
              "-p StandardError=journal",
              f"-p LoadCredentialEncrypted={CRED_NAME}:{CRED_FILE}",
              f"$SHELL -c '{cmd}'"
              ]) )

          if status != 0:
              raise Exception(f"systemd_run failed (status {status})")

          machine.log("systemd-run finished successfully")

      machine.wait_for_unit("multi-user.target")

      with subtest("Check whether TPM device exists"):
          machine.succeed("test -e /dev/tpm0")
          machine.succeed("test -e /dev/tpmrm0")

      with subtest("Check whether systemd-creds detects TPM2 correctly"):
          cmd = "systemd-creds has-tpm2"
          machine.log(f"Running \"{cmd}\"")
          (status, _) = machine.execute(cmd)

          # Check exit code equals 0 or 1 (1 means firmware support is missing, which is OK here)
          if status != 0 and status != 1:
              raise Exception("systemd-creds failed to detect TPM2")

      with subtest("Encrypt credential using systemd-creds"):
          machine.succeed(f"dd if=/dev/urandom of={CRED_RAW_FILE} bs=1k count=16")
          machine.succeed(f"systemd-creds --with-key=host+tpm2 encrypt --name=testkey {CRED_RAW_FILE} {CRED_FILE}")

      with subtest("Write provided credential and check for equality"):
          CRED_OUT_FILE = f"/root/{CRED_NAME}.out"
          systemd_run(machine, f"systemd-creds cat testkey > {CRED_OUT_FILE}")
          machine.succeed(f"cmp --silent -- {CRED_RAW_FILE} {CRED_OUT_FILE}")

      with subtest("Check whether systemd service can see credential in systemd-creds list"):
          systemd_run(machine, f"systemd-creds list | grep {CRED_NAME}")

      with subtest("Check whether systemd service can access credential in $CREDENTIALS_DIRECTORY"):
          systemd_run(machine, f"cmp --silent -- $CREDENTIALS_DIRECTORY/{CRED_NAME} {CRED_RAW_FILE}")
    '';
  }
)
