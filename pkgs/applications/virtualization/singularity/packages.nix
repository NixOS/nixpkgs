{ callPackage
, fetchFromGitHub
, nixos
, conmon
}:
let
  apptainer = callPackage
    (import ./generic.nix rec {
      pname = "apptainer";
      version = "1.3.0";
      projectName = "apptainer";

      src = fetchFromGitHub {
        owner = "apptainer";
        repo = "apptainer";
        rev = "refs/tags/v${version}";
        hash = "sha256-YqPPTs7cIiMbOc8jOwr8KgUBVu2pTPlSL0Vvw/1n4co=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).goModules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-lWo6ic3Tdv1UInA5MtEaAgiheCin2JSh4nmheUooENY=";

      extraDescription = " (previously known as Singularity)";
      extraMeta.homepage = "https://apptainer.org";
    })
    {
      # Apptainer doesn't depend on conmon
      conmon = null;

      # Apptainer builders require explicit --with-suid / --without-suid flag
      # when building on a system with disabled unprivileged namespace.
      # See https://github.com/NixOS/nixpkgs/pull/215690#issuecomment-1426954601
      defaultToSuid = null;
    };

  singularity = callPackage
    (import ./generic.nix rec {
      pname = "singularity-ce";
      version = "4.1.2";
      projectName = "singularity";

      src = fetchFromGitHub {
        owner = "sylabs";
        repo = "singularity";
        rev = "refs/tags/v${version}";
        hash = "sha256-/KTDdkCMkZ5hO+VYHzw9vB8FDWxg7PS1yb2waRJQngY=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).singularity.override { vendorHash = sha256; }).goModules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-4Nxj2PzZmFdvouWKyXLFDk8iuRhFuvyPW/+VRTw75Zw=";

      # Do not build conmon and squashfuse from the Git submodule sources,
      # Use Nixpkgs provided version
      extraConfigureFlags = [
        "--without-conmon"
        "--without-squashfuse"
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
