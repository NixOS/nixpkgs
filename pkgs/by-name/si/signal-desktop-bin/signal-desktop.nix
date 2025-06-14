{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop-bin";
  version = "7.57.0";

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-VHqlTZolY+x+egLrhC6p695dF1SCnB+wPoAwGPJmz/c=";
}
