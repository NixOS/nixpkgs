{ callPackage
, fetchFromGitHub
, nixos
, conmon
}:
let
  apptainer = callPackage
    (import ./generic.nix rec {
      pname = "apptainer";
<<<<<<< HEAD
      version = "1.2.2";
=======
      version = "1.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      projectName = "apptainer";

      src = fetchFromGitHub {
        owner = "apptainer";
        repo = "apptainer";
        rev = "v${version}";
<<<<<<< HEAD
        hash = "sha256-CpNuoG+QykP+HDCyFuIbZKYez5XnYrE75SWFoWu34rg=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).goModules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-Y0gOqg+WGgssXGEYHc9IFwiIpkb3hetlQI89vseAQPc=";
=======
        hash = "sha256-3F8qwP27IXcnnEYMnLzkCOxQDx7yej6QIZ40Wb5pk34=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).apptainer.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-PfFubgR/W1WBXIsRO+Kg7hA6ebeAcRiJlTlAZbnl19A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
      version = "3.11.4";
=======
      version = "3.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      projectName = "singularity";

      src = fetchFromGitHub {
        owner = "sylabs";
        repo = "singularity";
        rev = "v${version}";
<<<<<<< HEAD
        hash = "sha256-v8iHbn2OzK/egP2Go76BI74iX8izfy2PM4Uo8LsE8FY=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).singularity.override { vendorHash = sha256; }).goModules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-24Hnpq6LRh3JgaiJWCmHfJKoWLxsbceCdJutjPqZsX8=";
=======
        hash = "sha256-gdgg6VN3Ily+2Remz6dZBhhfWIxyaBa4bIlFcgrA/uY=";
      };

      # Update by running
      # nix-prefetch -E "{ sha256 }: ((import ./. { }).singularity.override { vendorHash = sha256; }).go-modules"
      # at the root directory of the Nixpkgs repository
      vendorHash = "sha256-mBhlH6LSmcJuc6HbU/3Q9ii7vJkW9jcikBWCl8oeMOk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
