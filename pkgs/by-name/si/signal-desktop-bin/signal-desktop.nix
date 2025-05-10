{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop-bin";
  version = "7.53.0";

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-zoonfIoPLESgPsoecHv7/ErLxIRDKL1rWnowYomT9G4=";
}
