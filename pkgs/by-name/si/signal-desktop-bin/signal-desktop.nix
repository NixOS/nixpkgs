{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } rec {
  pname = "signal-desktop-bin";
  version = "7.60.0";

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
  hash = "sha256-t/QQJ9G0xVXy+5GjV1l8jB3VGycyzMehKyxyIXuubtk=";
}
