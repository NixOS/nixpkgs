{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "systemd-creds") {
    # The systemd-creds provider uses systemd's native LoadCredentialEncrypted
    # mechanism.  Each secret gets a oneshot service that copies the decrypted
    # credential from $CREDENTIALS_DIRECTORY to the artifact target path.
    #
    # This allows services that expect file paths (the vast majority) to
    # work without being rewritten to use $CREDENTIALS_DIRECTORY directly.

    systemd.services = lib.mapAttrs' (name: secret:
      lib.nameValuePair "nixos-artifacts-creds-${name}" {
        description = "Provision systemd credential '${name}'";
        wantedBy = [ "nixos-artifacts-secrets.target" ];
        before = [ "nixos-artifacts-secrets.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # Load the credential from the system credential store.
          # The credential file should be placed at /etc/credstore/${name}
          # (or encrypted variant at /etc/credstore.encrypted/${name}).
          LoadCredential = "${name}:/etc/credstore/${name}";
        };

        script = ''
          install -D -m "${secret.mode}" /dev/null "${secret.path}"
          cp "$CREDENTIALS_DIRECTORY/${name}" "${secret.path}"
          chown "${secret.owner}:${secret.group}" "${secret.path}"
          chmod "${secret.mode}" "${secret.path}"
        '';
      }
    ) cfg.secrets;
  };
}
