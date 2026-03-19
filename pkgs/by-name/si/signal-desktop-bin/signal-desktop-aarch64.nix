{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "8.5.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/10287130-signal-desktop/signal-desktop-8.5.0-1.fc42.aarch64.rpm";
  hash = "sha256-FPdv91o49YE5F0SCrvwyZPmoQ8Txc5GMdEk5mODSUSs=";
}
