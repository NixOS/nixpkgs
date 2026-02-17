{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } rec {
  pname = "signal-desktop-bin";
  version = "7.89.0";

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-qGzQ+ZtOCKu69EBEoxVjR5PzgtlrSNBW6SBZ9eG3ooU=";
}
