{ fetchurl, bitwig-studio1, pulseaudio, xorg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.2.4";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "11ilcsah79p8v9bpz2r6mk3c6glrwm3idx8n2k4cwvldsg2yvifl";
  };

  buildInputs = oldAttrs.buildInputs ++ [ xorg.libXtst ];

  runtimeDependencies = [ pulseaudio ];

  installPhase = ''
    ${oldAttrs.installPhase}

    # recover commercial jre
    rm -f $out/libexec/lib/jre
    cp -r opt/bitwig-studio/lib/jre $out/libexec/lib
  '';
})
