{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf (config.boot.initrd.enable && config.boot.initrd.systemd.enable) {
    # Copy secrets into the initrd if they cannot be appended
    boot.initrd.systemd.contents = lib.mkIf (!config.boot.loader.supportsInitrdSecrets) (
      lib.mapAttrs' (
        _: scfg:
        let
          prefix = lib.optionalString scfg.intermediateSecretsDir "/.initrd-secrets";
        in
        lib.nameValuePair "${prefix}${scfg.path}" { inherit (scfg) source; }
      ) config.boot.initrd.secretPaths
    );

    # Copy secrets to their respective locations
    boot.initrd.systemd.services.initrd-nixos-copy-secrets =
      lib.mkIf
        (
          (builtins.any (x: x.intermediateSecretsDir) (builtins.attrValues config.boot.initrd.secretPaths))
          || config.boot.initrd.extraSecretsHook != ""
        )
        {
          description = "Copy secrets into place";
          # Run as early as possible
          wantedBy = [ "sysinit.target" ];
          before = [
            "cryptsetup-pre.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;

          # We write the secrets to /.initrd-secrets and move them because this allows
          # secrets to be written to /run. If we put the secret directly to /run and
          # drop this service, we'd mount the /run tmpfs over the secret, making it
          # invisible in stage 2.
          script = ''
            if [ -d /.initrd-secrets ]; then
              for secret in $(cd /.initrd-secrets; find . -type f -o -type l); do
                mkdir -p "$(dirname "/$secret")"
                cp "/.initrd-secrets/$secret" "/$secret"
              done
            fi
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };
    # The script needs this
    boot.initrd.systemd.extraBin.find = "${pkgs.findutils}/bin/find";
  };
}
