{
  stdenvNoCC,
}:

# The only reason this package exists is to pass nixpkgs-vet validations.
# https://github.com/NixOS/nixpkgs/pull/522287
stdenvNoCC.mkDerivation {
  pname = "libretroPackages";
  version = "0";

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    runHook postInstall
  '';

  meta = {
    description = "Dummy package for the libretro package set";
    platforms = [ ];
  };
}
