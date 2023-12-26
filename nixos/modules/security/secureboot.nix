{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkOption mkEnableOption optionalString;
in {
  options.boot.secureboot = {

    enable = mkEnableOption "Secure Boot support";

    signingCertificate = mkOption {
      default = null;
      type = types.nullOr types.pathInStore;
      description = lib.mdDoc ''
        Certificate file to use for verifying signed EFI binaries for
        Secure Boot.

        For official NixOS installer images, this will be the NixOS
        vendor certificate.

        Everywhere else, this should usually correspond to a Machine
        Owner Key (MOK, for shim-based Secure Boot) or database
        certificate (db, for Secure Boot without shim) enrolled on the
        machine being booted.
      '';
    };

    privateKeyFile = mkOption {
      default = null;
      type = types.nullOr types.pathInStore;
      description = lib.mdDoc ''
        Private key file to use for signing EFI binaries for Secure Boot.

        This is insecure (leaks the private key to the world-readable
        Nix store) and should only be used for testing!
      '';
    };

    shim = mkOption {
      type = types.pathInStore;
      description = ''
        Path to a signed shim binary.

        For most use cases, this should be the one signed with the
        official NixOS keys, which will allow booting on systems with
        Secure Boot enabled and only Microsoft keys trusted.
      '';
    };

    sbat = mkOption {
      type = types.nullOr types.pathInStore;
      default = null;
      description = ''
        Path to an SBAT CSV file which will be embedded in signed
        binaries for Secure Boot.
      '';
    };

    signingFunction = mkOption {
      type = types.functionTo types.pathInStore;
      description = ''
        Function which, given a path, produces a derivation that signs
        that path. Should return the path to the signed file in the
        derivation output.
      '';
    };

    signFile = mkOption {
      type = types.functionTo types.pathInStore;
      readOnly = true;
      description = ''
        Wraps signingFunction with a derivation that verifies the signature.
      '';
    };
  };
  config = {
    boot.secureboot.signingFunction = lib.mkDefault (lib.warn "Using insecure secure boot signing function which leaks the private key to the store"
      (file: let
        name = baseNameOf file;
        drv = pkgs.runCommand "${name}-signed" { nativeBuildInputs = [ pkgs.buildPackages.sbsigntool ]; } ''
          mkdir -p $out
          sbsign \
            --cert ${config.boot.secureboot.signingCertificate} \
            --output $out/${name} \
            ${optionalString (config.boot.secureboot.privateKeyFile != null) "--key ${config.boot.secureboot.privateKeyFile}"} \
            ${file}
        '';
      in "${drv}/${name}"
      ));
    boot.secureboot.signFile = file: let
      name = baseNameOf file;
      signedFile = config.boot.secureboot.signingFunction file;
      # TODO: validate that the signed thing is the same as the original
      verifyDrv = pkgs.runCommand "${name}-signed-verified" {
        nativeBuildInputs = [ pkgs.buildPackages.sbsigntool ];
        passthru.unsigned = file;
      } ''
        sbverify --cert ${config.boot.secureboot.signingCertificate} ${signedFile}
        mkdir -p $out
        cp -L ${signedFile} $out/
      '';
    in
      if config.boot.secureboot.signingCertificate == null then file else "${verifyDrv}/${name}";
  };
}
