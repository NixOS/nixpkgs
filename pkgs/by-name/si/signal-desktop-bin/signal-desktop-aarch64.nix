{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.85.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-43-aarch64/10010734-signal-desktop/signal-desktop-7.85.0-1.fc43.aarch64.rpm";
  hash = "sha256-ewjW5mwPph1xZXtqwYPishJ/zYjzpA/df+5WvdcEfWI=";
}
