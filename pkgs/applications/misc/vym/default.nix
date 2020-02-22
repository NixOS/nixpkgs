{ stdenv, mkDerivation, fetchurl, pkgconfig, qmake, qtscript, qtsvg }:

mkDerivation rec {
  pname = "vym";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/vym/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0lyf0m4y5kn5s47z4sg10215f3jsn3k1bl389jfbh2f5v4srav4g";
  };

  # Hardcoded paths scattered about all have form share/vym
  # which is encouraging, although we'll need to patch them (below).
  qmakeFlags = [
    "DATADIR=${placeholder "out"}/share"
    "DOCDIR=${placeholder "out"}/share/doc/vym"
  ];

  postPatch = ''
    for x in \
      exportoofiledialog.cpp \
      main.cpp \
      mainwindow.cpp \
      tex/*.{tex,lyx}; \
    do
      substituteInPlace $x \
        --replace /usr/share/vym $out/share/vym \
        --replace /usr/local/share/vym $out/share/vym \
        --replace /usr/share/doc $out/share/doc/vym
    done
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtscript qtsvg ];

  postInstall = ''
    install -Dm755 -t $out/share/man/man1 doc/*.1.gz
  '';

  dontGzipMan = true;

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
