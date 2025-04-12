{
  callPackage,
  sratom,
  flex,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    pname = "sherlock";
    version = "0.28.0";

    sha256 = "07zj88s1593fpw2s0r3ix7cj2icfd9zyirsyhr2i8l6d30b6n6fb";

    additionalBuildInputs = [
      sratom
      flex
    ];

    description = "Plugins for visualizing LV2 atom, MIDI and OSC events";
  }
)
