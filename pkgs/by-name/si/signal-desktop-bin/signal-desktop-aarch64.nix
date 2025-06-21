{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.58.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09183198-signal-desktop/signal-desktop-7.58.0-1.fc42.aarch64.rpm";
  hash = "sha256-0Ix+1SdvmKLVbtGzbjUupvVzdWAJFNQ6sSAIt+T9fHo=";
}
