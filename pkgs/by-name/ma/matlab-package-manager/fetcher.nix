{
  lib,
  stdenvNoCC,
  matlab-package-manager,
}:

{
  release,
  update ? 0,
  # The full list of correctly formatted product names can be found within the template input files
  # https://github.com/mathworks-ref-arch/matlab-dockerfile/tree/main/mpm-input-files
  extra-products ? [ ],
  hash,
}:

let
  version = "${release}U${toString update}";
  products = [ "MATLAB" ] ++ extra-products;
in
stdenvNoCC.mkDerivation {
  pname = "matlab-download";
  inherit products version;

  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    # As mpm is bubblewrapped, it cannot write to $out directly
    # https://github.com/NixOS/nixpkgs/issues/239017
    ${lib.getExe matlab-package-manager} download --release "$version" --platforms glnxa64 --destination matlab --products "''${products[@]}"

    # mpm 2024.4 now bundles mpm with the downloaded files. Remove this so the hashes are the same as prior mpm versions.
    rm -rf matlab/mpm

    mv matlab $out
  '';

  dontFixup = true;

  # The MATLAB installation isn't 100% deterministic due to how the classpath.txt file is generated.
  # But mpm download does appear to be deterministic. So create a fixed output derivation from the
  # downloaded files, and then run the installer.
  outputHashAlgo = if hash == "" then "sha256" else null;
  outputHashMode = "recursive";
  outputHash = hash;

  passthru.matlab-download = {
    inherit products release update;
  };
}
