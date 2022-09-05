{ lib, stdenv, fetchurl, fftwFloat, gtk2, ladspaPlugins, libjack2, liblo, libxml2
, makeWrapper, pkg-config, perlPackages
}:

stdenv.mkDerivation rec {
  version = "0.95.0";
  pname = "jamin";

  src = fetchurl {
    url = "mirror://sourceforge/jamin/jamin-${version}.tar.gz";
    sha256 = "0g5v74cm0q3p3pzl6xmnp4rqayaymfli7c6z8s78h9rgd24fwbvn";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ fftwFloat gtk2 ladspaPlugins libjack2 liblo libxml2 ]
    ++ (with perlPackages; [ perl XMLParser ]);

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #     ld: jamin-preferences.o:/build/jamin-0.95.0/src/hdeq.h:64: multiple definition of
  #       `l_notebook1'; jamin-callbacks.o:/build/jamin-0.95.0/src/hdeq.h:64: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  NIX_LDFLAGS = "-ldl";

  postInstall = ''
    wrapProgram $out/bin/jamin --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa
  '';

  meta = with lib; {
    homepage = "http://jamin.sourceforge.net";
    description = "JACK Audio Mastering interface";
    license = licenses.gpl2;
    maintainers = [ maintainers.nico202 ];
    platforms = platforms.linux;
  };
}
