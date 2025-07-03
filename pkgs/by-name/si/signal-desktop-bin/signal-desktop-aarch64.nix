{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.62.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09281218-signal-desktop/signal-desktop-7.62.0-1.fc42.aarch64.rpm";
  hash = "sha256-t7xQ6SwIYskZsKAY8FnzD0lLb+Hn2u4dW3I2VllmXYw=";
}
