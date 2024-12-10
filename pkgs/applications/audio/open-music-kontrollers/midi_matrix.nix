{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    pname = "midi_matrix";
    version = "0.30.0";

    sha256 = "1nwmfxdzk4pvbwcgi3d7v4flqc10bmi2fxhrhrpfa7cafqs40ib6";

    description = "An LV2 MIDI channel matrix patcher";
  }
)
