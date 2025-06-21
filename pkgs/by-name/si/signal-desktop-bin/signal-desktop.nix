{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } rec {
  pname = "signal-desktop-bin";
  version = "7.58.0";

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-zZ63AE+qb0lrGtGUtU4FV6pHDO2DUV2vknz3a4+f4aA=";
}
