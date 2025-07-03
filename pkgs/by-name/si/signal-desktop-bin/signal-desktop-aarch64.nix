{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
  version = "7.63.0";

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09309822-signal-desktop/signal-desktop-7.63.0-1.fc42.aarch64.rpm";
  hash = "sha256-zn8Mm6HY95Uw30O92YhTyhH7Di1odhG4jZ9U8POO5ro=";
}
