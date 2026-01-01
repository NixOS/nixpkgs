{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } {
  pname = "signal-desktop-bin";
<<<<<<< HEAD
  version = "7.83.0";
=======
  version = "7.80.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  libdir = "usr/lib64/signal-desktop";
  bindir = "usr/bin";
  extractPkg = ''
    mkdir -p $out
    bsdtar -xf $downloadedFile -C "$out"
  '';

<<<<<<< HEAD
  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09932085-signal-desktop/signal-desktop-7.83.0-1.fc42.aarch64.rpm";
  hash = "sha256-OY+sHfAC/WTC2MkjFjlImYXLNflFNAw4VRcbQ/B3s10=";
=======
  url = "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/09815595-signal-desktop/signal-desktop-7.80.0-1.fc42.aarch64.rpm";
  hash = "sha256-RunFdBUGBmDmztWdn9Rjbotnzwiid+gCIKPz1Nrc8v0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
