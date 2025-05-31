{ callPackage }:
callPackage ./generic.nix { } {
  pname = "signal-desktop-bin";
  version = "7.55.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09073923-signal-desktop/signal-desktop-7.55.0-1.fc42.aarch64.rpm";
  hash = "sha256-rRt2hYyj6kyN0RCupy+hpRJuzq0aaUzP2tsVr2Qd5V4=";
}
