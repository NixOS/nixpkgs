{ fetchurl, bitwig-studio1,
  pulseaudio }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  pname = "bitwig-studio";
  version = "2.5";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "1zkiz36lhck3qvl0cp0dq6pwbv4lx4sh9wh0ga92kx5zhvbjm098";
  };

  runtimeDependencies = [
    pulseaudio
  ];
})
