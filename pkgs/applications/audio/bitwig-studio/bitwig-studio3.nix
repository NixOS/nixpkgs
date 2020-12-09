{ fetchurl, bitwig-studio1, pulseaudio, libjack2, xorg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.3";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "014xv8xisx940a7nh4r7chpp58snvyams499xk62iayqqy1zgalv";
  };

  buildInputs = oldAttrs.buildInputs ++ [ xorg.libXtst ];

  runtimeDependencies = [ pulseaudio libjack2 ];

  installPhase = ''
    ${oldAttrs.installPhase}

    # recover commercial jre
    rm -f $out/libexec/lib/jre
    cp -r opt/bitwig-studio/lib/jre $out/libexec/lib
  '';
})
