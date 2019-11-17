{ stdenv, fetchurl, pkgconfig, qmake, qtsvg, qtscript, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "vym";
  version = "2.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/vym/2.7.0/${pname}-${version}.tar.bz2";
    sha256 = "1rnrfqlff7wv6yni8bvff8n90pmn82k82zd4sn1jsx9r1n3qsfkh";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig qmake wrapQtAppsHook ];
  buildInputs = [ qtsvg qtscript ];

  meta = with stdenv.lib; {
    description = "A mind-mapping software";
    longDescription = ''
      VYM (View Your Mind) is a tool to generate and manipulate maps which show your thoughts.
      Such maps can help you to improve your creativity and effectivity. You can use them
      for time management, to organize tasks, to get an overview over complex contexts,
      to sort your ideas etc.

      Maps can be drawn by hand on paper or a flip chart and help to structure your thoughs.
      While a tree like structure like shown on this page can be drawn by hand or any drawing software
      vym offers much more features to work with such maps.
    '';
    homepage = http://www.insilmaril.de/vym/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
