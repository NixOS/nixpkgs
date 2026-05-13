{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;
in {
  config = lib.mkIf (cfg.enable && cfg.provider == "dummy") {
    # The dummy provider writes plaintext placeholder values into the target
    # paths. It exists solely for CI/CD and NixOS VM integration tests where
    # real encryption keys are unavailable.
    #
    # Each secret gets its own oneshot service so that failures are isolated
    # and ordering is per-secret.

    systemd.services = lib.mapAttrs' (name: secret:
      let
        # Write the dummy content to a Nix store file, then copy it at
        # runtime.  This avoids shell-injection via the dummy string.
        dummyContent = pkgs.writeText "dummy-${name}" secret.dummy;
      in lib.nameValuePair "nixos-artifacts-dummy-${name}" {
        description = "Provision dummy secret '${name}'";
        wantedBy = [ "nixos-artifacts-secrets.target" ];
        before = [ "nixos-artifacts-secrets.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          install -D -m "${secret.mode}" /dev/null "${secret.path}"
          cp "${dummyContent}" "${secret.path}"
          chown "${secret.owner}:${secret.group}" "${secret.path}"
          chmod "${secret.mode}" "${secret.path}"
        '';
      }
    ) cfg.secrets;
  };
}
