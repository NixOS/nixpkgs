{ fetchurl, bitwig-studio1, pulseaudio, xorg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.1.3";

  src = fetchurl {
    url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "11z5flmp55ywgxyccj3pzhijhaggi42i2pvacg88kcpj0cin57vl";
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
