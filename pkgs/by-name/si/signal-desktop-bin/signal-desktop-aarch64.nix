{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.79.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09795013-signal-desktop/signal-desktop-7.79.0-1.fc42.aarch64.rpm";
  hash = "sha256-1XH9gw5/1n10u9d67EM2Y//6+oywE0ziv2ZXafL+h0Q=";
}
