{ callPackage
, fetchFromGitHub
, nixos
, conmon
}:
let
  apptainer = callPackage
    (import ./generic.nix rec {
      pname = "apptainer";
      version = "1.1.5";
      projectName = "apptainer";

      src = fetchFromGitHub {
        owner = "apptainer";
        repo = "apptainer";
        rev = "v${version}";
        hash = "sha256-onJkpHJNsO0cQO2m+TmdMuMkuvH178mDhOeX41bYFic=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-tAnh7A8Lw5KtY7hq+sqHMEUlgXvgeeCKKIfRZFoRtug=";

      extraDescription = " (previously known as Singularity)";
      extraMeta.homepage = "https://apptainer.org";
    })
    {
      # Apptainer doesn't depend on conmon
      conmon = null;

      # defaultToSuid becomes false since Apptainer 1.1.0
      # https://github.com/apptainer/apptainer/pull/495
      # https://github.com/apptainer/apptainer/releases/tag/v1.1.0
      defaultToSuid = false;
    };

  singularity = callPackage
    (import ./generic.nix rec {
      pname = "singularity-ce";
      version = "3.10.4";
      projectName = "singularity";

      src = fetchFromGitHub {
        owner = "sylabs";
        repo = "singularity";
        rev = "v${version}";
        hash = "sha256-bUnQXQVwaVA3Lkw3X9TBWqNBgiPxAVCHnkq0vc+CIsM=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).singularity.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-K8helLcOuz3E4LzBE9y3pnZqwdwhO/iMPTN1o22ipVg=";

      # Do not build conmon from the Git submodule source,
      # Use Nixpkgs provided version
      extraConfigureFlags = [
        "--without-conmon"
      ];

      extraDescription = " (Sylabs Inc's fork of Singularity, a.k.a. SingularityCE)";
      extraMeta.homepage = "https://sylabs.io/";
    })
    {
      defaultToSuid = true;
    };

  genOverridenNixos = package: packageName: (nixos {
    programs.singularity = {
      enable = true;
      inherit package;
    };
  }).config.programs.singularity.packageOverriden.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      description = "";
      longDescription = ''
        This package produces identical store derivations to `pkgs.${packageName}`
        overriden and installed by the NixOS module `programs.singularity`
        with default configuration.

        This is for binary substitutes only. Use pkgs.${packageName} instead.
      '';
    };
  });
in
{
  inherit apptainer singularity;

  apptainer-overriden-nixos = genOverridenNixos apptainer "apptainer";
  singularity-overriden-nixos = genOverridenNixos singularity "singularity";
}
