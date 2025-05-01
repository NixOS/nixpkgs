{ callPackage }:
callPackage ./generic.nix { } {
  pname = "signal-desktop-bin";
  version = "7.54.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09035581-signal-desktop/signal-desktop-7.54.0-1.fc42.aarch64.rpm";
  hash = "sha256-s5LeCSorejks+uAAzlz7K96tbV0mjJGoDUgO1NqTQAA=";
}
