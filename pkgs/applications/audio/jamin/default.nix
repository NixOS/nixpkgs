{ stdenv, fetchurl, fftwFloat, gtk2, ladspaPlugins, libjack2, liblo, libxml2
, makeWrapper, pkgconfig, perl, perlXMLParser
}:

stdenv.mkDerivation {
  name = "jamin-0.95.0";

  src = fetchurl {
    url = mirror://sourceforge/jamin/jamin-0.95.0.tar.gz;
    sha256 = "0g5v74cm0q3p3pzl6xmnp4rqayaymfli7c6z8s78h9rgd24fwbvn";
  };

  buildInputs = [
    fftwFloat gtk2 ladspaPlugins libjack2 liblo libxml2 pkgconfig perl
    perlXMLParser makeWrapper
  ];
  
  postInstall = ''
    wrapProgram $out/bin/jamin --set LADSPA_PATH ${ladspaPlugins}/lib/ladspa
  '';

  meta = with stdenv.lib; {
    homepage = http://jamin.sourceforge.net;
    description = "JACK Audio Mastering interface";
    license = licenses.gpl2;
    maintainers = [ maintainers.nico202 ];
    platforms = platforms.linux;
  };
}
