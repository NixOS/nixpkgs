{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.80.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09815595-signal-desktop/signal-desktop-7.80.0-1.fc42.aarch64.rpm";
  hash = "sha256-RunFdBUGBmDmztWdn9Rjbotnzwiid+gCIKPz1Nrc8v0=";
}
