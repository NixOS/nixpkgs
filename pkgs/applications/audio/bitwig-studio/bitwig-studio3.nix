{ fetchurl, bitwig-studio1,
  pulseaudio }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.0";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "0p7wi1srfzalb0rl94vqppfbnxdfwqzgg5blkdwkf4sx977aihpv";
  };

  runtimeDependencies = [
    pulseaudio
  ];
})
