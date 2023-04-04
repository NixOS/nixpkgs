{ callPackage
, fetchFromGitHub
, nixos
, conmon
}:
let
  apptainer = callPackage
    (import ./generic.nix rec {
      pname = "apptainer";
      version = "1.1.7";
      projectName = "apptainer";

      src = fetchFromGitHub {
        owner = "apptainer";
        repo = "apptainer";
        rev = "v${version}";
        hash = "sha256-3F8qwP27IXcnnEYMnLzkCOxQDx7yej6QIZ40Wb5pk34=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-PfFubgR/W1WBXIsRO+Kg7hA6ebeAcRiJlTlAZbnl19A=";

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
      version = "3.11.1";
      projectName = "singularity";

      src = fetchFromGitHub {
        owner = "sylabs";
        repo = "singularity";
        rev = "v${version}";
        hash = "sha256-gdgg6VN3Ily+2Remz6dZBhhfWIxyaBa4bIlFcgrA/uY=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).singularity.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-mBhlH6LSmcJuc6HbU/3Q9ii7vJkW9jcikBWCl8oeMOk=";

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
