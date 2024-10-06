{ stdenv, fetchzip, lib, callPackage }:

let
  pname = "aerospace";
  # Version must be a literal string as package has a capital letter in it
  # whilst nixpkgs forbids capitals in version names
  ghReleaseVersion = "0.9.0-Beta";
  version = lib.strings.toLower ghReleaseVersion;
  meta = with lib; {
    license = licenses.mit;
    mainProgram = "aerospace";
    homepage = "https://github.com/nikitabobko/AeroSpace";
    description = "An i3-like tiling window manager for macOS";
    platforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [ t-monaghan ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
in
stdenv.mkDerivation {
  inherit pname version meta;

  src = fetchzip {
    url = "https://github.com/nikitabobko/aerospace/releases/download/v${ghReleaseVersion}/AeroSpace-v${ghReleaseVersion}.zip";
    hash = "sha256-UVNMjKPMUDuSKPMtLLBb3Lqu5Xocp9X99i+tPjktdbA=";
  };

  unpackPhase = ''
    ls -lah $src/
    cp -r $src/ $out/
  '';

  passthru.tests.can-print-version = callPackage ./test-can-print-version.nix { };
}
