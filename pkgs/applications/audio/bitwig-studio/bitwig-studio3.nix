{ fetchurl, bitwig-studio1,
  pulseaudio }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.0.3";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "162l95imq2fb4blfkianlkymm690by9ri73xf9zigknqf0gacgsa";
  };

  runtimeDependencies = [
    pulseaudio
  ];
})
