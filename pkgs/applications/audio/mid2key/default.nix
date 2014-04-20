{ stdenv, fetchurl, alsaLib, libX11, libXi, libXtst, xextproto }:

stdenv.mkDerivation rec {
  name = "mid2key-r1";

  src = fetchurl {
    url = "http://mid2key.googlecode.com/files/${name}.tar.gz";
    sha256 = "0j2vsjvdgx51nd1qmaa18mcy0yw9pwrhbv2mdwnf913bwsk4y904";
  };

  unpackPhase = "tar xvzf $src";

  buildInputs = [ alsaLib libX11 libXi libXtst xextproto ];

  buildPhase = "make";

  installPhase = "mkdir -p $out/bin && mv mid2key $out/bin";

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/mid2key/;
    description = "A simple tool which maps midi notes to simulated keystrokes";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
