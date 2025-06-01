{ callPackage }:
callPackage ./generic.nix { } {
  pname = "signal-desktop-bin";
  version = "7.56.1";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-41-aarch64/09139013-signal-desktop/signal-desktop-7.56.1-1.fc41.aarch64.rpm";
  hash = "sha256-9u4rOWL1tIxUsC1IxIrz6IJJHBmvVT/BVDF0eaJ6LYY=";
}
