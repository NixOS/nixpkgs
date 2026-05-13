{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "dummy") {
    # For the dummy provider, we generate a one-shot systemd service that writes
    # the dummy string into the required path. This avoids writing directly to the Nix store.

    systemd.services = lib.mapAttrs' (name: secret:
      let
        resolvedPath = if secret.path != null then builtins.toString secret.path else "/run/secrets/${name}";
      in lib.nameValuePair "nixos-artifacts-dummy-${name}" {
        description = "Provision dummy secret for ${name}";
        wantedBy = [ "nixos-artifacts-secrets.target" ];
        before = [ "nixos-artifacts-secrets.target" ];
        
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "provision-dummy-${name}" ''
            mkdir -p $(dirname "${resolvedPath}")
            # Use printf to avoid trailing newlines unless explicitly in the dummy string
            ${pkgs.coreutils}/bin/printf '%s' "${secret.dummy}" > "${resolvedPath}"
            chown ${secret.owner}:${secret.group} "${resolvedPath}"
            chmod ${secret.mode} "${resolvedPath}"
          '';
        };
      }
    ) cfg.secrets;
  };
}
