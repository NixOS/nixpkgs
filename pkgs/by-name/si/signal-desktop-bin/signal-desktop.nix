{ callPackage, commandLineArgs }:
callPackage ./generic.nix { inherit commandLineArgs; } rec {
  pname = "signal-desktop-bin";
<<<<<<< HEAD
  version = "7.83.0";
=======
  version = "7.80.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  libdir = "opt/Signal";
  bindir = libdir;
  extractPkg = "dpkg-deb -x $downloadedFile $out";

  url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
<<<<<<< HEAD
  hash = "sha256-DhtOOve8dloIbTi78gLHWars/Y9Fv6YkLkHHpRK7OWY=";
=======
  hash = "sha256-d0OTlGtTGN4d7ZIShhVc39TiSJvEg9UMonqeP++R7x4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
