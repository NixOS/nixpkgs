{ config, options, utils, pkgs, lib, ... }:
let
  enabledBootloaders = builtins.attrNames (lib.filterAttrs (utils.enabledBootloader options.boot.loader) config.boot.loader);
  # It's all or nothing, either everyone supports it, either no one.
  supportsInitrdSecrets = builtins.all (bl: bl.supportsInitrdSecrets) enabledBootloaders;
in
{
  config = lib.mkIf (config.boot.initrd.enable && config.boot.initrd.systemd.enable) {
    # Copy secrets into the initrd if they cannot be appended
    boot.initrd.systemd.contents = lib.mkIf (!supportsInitrdSecrets)
      (lib.mapAttrs' (dest: source: lib.nameValuePair "/.initrd-secrets/${dest}" { source = if source == null then dest else source; }) config.boot.initrd.secrets);

    # Copy secrets to their respective locations
    boot.initrd.systemd.services.initrd-nixos-copy-secrets = lib.mkIf (config.boot.initrd.secrets != {}) {
      description = "Copy secrets into place";
      # Run as early as possible
      wantedBy = [ "sysinit.target" ];
      before = [ "cryptsetup-pre.target" "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      unitConfig.DefaultDependencies = false;

      # We write the secrets to /.initrd-secrets and move them because this allows
      # secrets to be written to /run. If we put the secret directly to /run and
      # drop this service, we'd mount the /run tmpfs over the secret, making it
      # invisible in stage 2.
      script = ''
        for secret in $(cd /.initrd-secrets; find . -type f -o -type l); do
          mkdir -p "$(dirname "/$secret")"
          cp "/.initrd-secrets/$secret" "/$secret"
        done
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
