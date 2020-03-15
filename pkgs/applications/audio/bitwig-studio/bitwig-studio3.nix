{ stdenv, fetchurl, bitwig-studio2, xorg, ... }:

bitwig-studio2.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "3.1.3";

  src = fetchurl {
    url =
      "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "11z5flmp55ywgxyccj3pzhijhaggi42i2pvacg88kcpj0cin57vl";
  };

  buildInputs = bitwig-studio2.buildInputs ++ [ xorg.libXtst ];

  installPhase = ''
    ${oldAttrs.installPhase}

    # recover commercial jre
    rm -f $out/libexec/lib/jre
    cp -r opt/bitwig-studio/lib/jre $out/libexec/lib
  '';

})
