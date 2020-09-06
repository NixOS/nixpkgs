{ fetchurl, bitwig-studio1, pulseaudio, xorg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.2.7";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "1mj9kii4bnk5w2p18hypwy8swkpzkaqw98q5fsjq362x4qm0b3py";
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
