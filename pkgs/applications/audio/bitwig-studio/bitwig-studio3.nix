{ fetchurl, bitwig-studio1,
  pulseaudio }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.0.1";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "0k25p1j4kgnhm7p90qp1cz79xddgi6nh1nx1y5wz42x8qrpxya0s";
  };

  runtimeDependencies = [
    pulseaudio
  ];
})
