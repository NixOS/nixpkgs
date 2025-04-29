{ callPackage }:
callPackage ./generic.nix { } {
  pname = "signal-desktop-bin";
  version = "7.52.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/08956500-signal-desktop/signal-desktop-7.52.0-1.fc42.aarch64.rpm";
  hash = "sha256-kQbCkswCNRnz/K6KpZKJ55bCaM2YFL9wW+erVA+3Nok=";
}
