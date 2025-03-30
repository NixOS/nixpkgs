{ callPackage }:
callPackage ./generic.nix { } {
  pname = "signal-desktop";
  version = "7.47.0-1";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/08795262-signal-desktop/signal-desktop-7.47.0-1.fc42.aarch64.rpm";
  hash = "sha256-CDj9OX6OfEzbP8kusqnWN+MCPPEi9u2Hj1LkpsCg3vI=";
}
