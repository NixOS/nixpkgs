{ lib, config, ... }: let
  cfg = config.boot.initrd.verify;
  nix = config.nix.package;
in {
  options.boot.initrd.verify = {
    enable = lib.mkEnableOption "verifying the stage 2 closure during initrd";
    trustedPublicKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = lib.mdDoc "Keys to verify the closure against.";
    };
    sigsNeeded = lib.mkOption {
      type = lib.types.int;
      description = lib.mdDoc "Number of signatures required.";
      default = 1;
    };
    signing = {
      enable = lib.mkEnableOption "signing the system profiles when configuring the boot loader";
      keyFile = lib.mkOption {
        type = lib.types.path;
        description = lib.mdDoc "Path to the signing key.";
        example = "/run/keys/signing-key";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      systemd.storePaths = [ "${nix}/bin/nix" ];
      systemd.services.verify-store = {
        requiredBy = [ "initrd-nixos-activation.service" ];
        before = [ "initrd-nixos-activation.service" ];
        requires = [ "initrd-fs.target" ];
        after = [ "initrd-fs.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${nix}/bin/nix --experimental-features nix-command verify -r --store /sysroot --trusted-public-keys \"${lib.concatStringsSep " " cfg.trustedPublicKeys}\" ${if cfg.sigsNeeded == 0 then "--no-trust" else "--sigs-needed " + toString cfg.sigsNeeded} \${NIXOS_SYSTEM_CLOSURE}";
        };
      };
    };

    boot.loader.systemd-boot.extraInstallCommands = lib.mkIf cfg.signing.enable ''
      echo Signing system generations
      nix --experimental-features nix-command store sign -k ${toString cfg.signing.keyFile} -r /nix/var/nix/profiles/system*
    '';
  };
}
