{ pkgs, ... }:
let

  # We need proper derivations to add it to the nixImageBase.
  mkDrv =
    name: src:
    pkgs.stdenv.mkDerivation {
      inherit name src;
      installPhase = ''
        mkdir -p $out
        cp -r $src/* $out/
      '';
    };
in
{
  commonRoot = mkDrv "common-root-files" ./common-root;
  containers = mkDrv "containers-files" ./containers;
  nixImage = mkDrv "nix-image-files" ./nix-image;
  ubuntuImage = mkDrv "ubuntu-image-files" ./ubuntu-image;
  fakeNixpkgs = mkDrv "fake-nixpkgs-files" ./fake-nixpkgs;
}
