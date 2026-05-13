{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "systemd-creds") {
    # For systemd-creds, we use LoadCredential in systemd units.
    # The provider handles copying the decrypted credentials to the expected /run/secrets/ location
    # so that services expecting file paths do not need to be rewritten to use $CREDENTIALS_DIRECTORY.

    systemd.services = lib.mapAttrs' (name: secret: 
      let
        resolvedPath = if secret.path != null then secret.path else "/run/secrets/${name}";
      in lib.nameValuePair "nixos-artifacts-creds-${name}" {
        description = "Provision systemd credential for ${name}";
        wantedBy = [ "nixos-artifacts-secrets.target" ];
        before = [ "nixos-artifacts-secrets.target" ];
        
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # systemd-creds requires LoadCredential configuration
          LoadCredential = "${name}:/etc/systemd/creds/${name}.cred";
          # Script ensures the directory exists and copies the credential with proper permissions
          ExecStart = pkgs.writeShellScript "provision-${name}" ''
            mkdir -p $(dirname "${resolvedPath}")
            cp "$CREDENTIALS_DIRECTORY/${name}" "${resolvedPath}"
            chown ${secret.owner}:${secret.group} "${resolvedPath}"
            chmod ${secret.mode} "${resolvedPath}"
          '';
        };
      }
    ) cfg.secrets;
  };
}
