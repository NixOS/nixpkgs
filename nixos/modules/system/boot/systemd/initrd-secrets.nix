{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.boot.initrd.enable && config.boot.initrd.systemd.enable) {
    # Copy secrets into the initrd if they cannot be appended
    boot.initrd.systemd.contents = lib.mkIf (!config.boot.loader.supportsInitrdSecrets)
      (lib.mapAttrs' (dest: source: lib.nameValuePair "/.initrd-secrets/${dest}" { source = if source == null then dest else source; }) config.boot.initrd.secrets);

    # Copy secrets to their respective locations
    boot.initrd.systemd.services.initrd-nixos-copy-secrets = lib.mkIf (config.boot.initrd.secrets != {}) {
      description = "Copy secrets into place";
      # Run as early as possible
      wantedBy = [ "sysinit.target" ];
      before = [ "cryptsetup-pre.target" ];
      unitConfig.DefaultDependencies = false;

      # We write the secrets to /.initrd-secrets and move them because this allows
      # secrets to be written to /run. If we put the secret directly to /run and
      # drop this service, we'd mount the /run tmpfs over the secret, making it
      # invisible in stage 2.
      script = ''
        for secret in $(cd /.initrd-secrets; find . -type f); do
          mkdir -p "$(dirname "/$secret")"
          cp "/.initrd-secrets/$secret" "/$secret"
        done
      '';

      unitConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
    # The script needs this
    boot.initrd.systemd.extraBin.find = "${pkgs.findutils}/bin/find";
  };
}
