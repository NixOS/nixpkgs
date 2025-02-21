{ callPackage }:
callPackage ./generic.nix { } rec {
  pname = "signal-desktop";
  version = "7.43.0-1";

  dir = "Signal";
  libdir = "usr/lib64/${pname}";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    rpm2cpio $downloadedFile | cpio -imvdD"$out"
  '';

  hash = "sha256-aWTVKbnH4cu5PI+T6vl6ssE9+B0XBqilmTMjCEVOFrA=";
  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/08673520-signal-desktop/signal-desktop-7.43.0-1.fc42.aarch64.rpm";
}
