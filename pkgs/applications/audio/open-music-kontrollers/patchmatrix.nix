{ callPackage, libjack2, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "patchmatrix";
  version = "0.24.0";

  url = "https://git.open-music-kontrollers.ch/lad/${pname}/snapshot/${pname}-${version}.tar.xz";
  sha256 = "1wm5bkr5c68ii9cksgq6h9x26c3k7lynmkla1rrwlxkp371yyrz8";

  additionalBuildInputs = [ libjack2 ];

  description = "A JACK patchbay in flow matrix style";
})
