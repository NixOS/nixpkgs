# tpm2-totp with Plymouth {#module-boot-plymouth-tpm2-totp}

[tpm2-totp](https://github.com/tpm2-software/tpm2-totp) attests the trustworthiness of a device against a human using time-based one-time passwords. This module uses a `tpm2-totp` configuration to display a TOTP at boot using Plymouth.

## Quick start {#module-boot-plymouth-tpm2-totp-quick-start}

### 1. Enable modules {#module-boot-plymouth-tpm2-totp-quick-start-enable}

```nix
{
  boot.plymouth.tpm2-totp.enable = true;

  # Plymouth and systemd initrd/stage-1 are required:
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
}
```

Switch to the new configuration before proceeding to the next step.

### 2. Configure `tpm2-totp` {#module-boot-plymouth-tpm2-totp-quick-start-configure}

Generate a new TOTP secret and save the secret in your chosen authenticator app. See `man tpm2-totp` for commands and configuration examples.

More information, including security considerations, can be found in the `README.md` in the [tpm2-totp](https://github.com/tpm2-software/tpm2-totp) repository. Be sure to select the tag for the version of `tpm2-totp` you have installed.

### 3. Check configuration {#module-boot-plymouth-tpm2-totp-quick-start-check}

Reboot and you should see the TOTP appear on the Plymouth boot screen. The TOTP should match the code displayed in your authenticator app (or the code immediately before/after).
