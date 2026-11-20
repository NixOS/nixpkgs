{
  lib,
  stdenv,
  fetchurl,
  unzip,
  fltk-minimal,
  which,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fltrator";
  version = "2.3";

  src = fetchurl {
    url = "mirror://sourceforge/fltrator/fltrator-${finalAttrs.version}-code.zip";
    sha256 = "125aqq1sfrm0c9cm6gyylwdmc8xrb0rjf563xvw7q28sdbl6ayp7";
  };

  buildInputs = [
    fltk-minimal
    libjpeg
  ];
  nativeBuildInputs = [
    unzip
    which
  ];

  postPatch = ''
    substituteInPlace src/fltrator.cxx\
      --replace 'home += "fltrator/"' "home = \"$out/fltrator/\""
    substituteInPlace src/fltrator-landscape.cxx\
      --replace 'home += "fltrator/"' "home = \"$out/fltrator/\""
    substituteInPlace rsc/fltrator.desktop \
      --replace 'Exec=fltrator' "Exec=$out/bin/fltrator"
  '';

  dontAddPrefix = true;

  makeFlags = [
    "HOME=$(out)"
    "RSC_PATH=$(out)/fltrator"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp rsc/fltrator.desktop $out/share/applications
    mkdir -p $out/share/icons/hicolor/128x128/apps/
    cp rsc/fltrator-128.png $out/share/icons/hicolor/128x128/apps/fltrator2.png
  '';

  meta = {
    description = "Simple retro style arcade side-scroller game";
    longDescription = ''
      FLTrator is a simple retro style arcade side-scroller game in which you steer a spaceship through a landscape with hostile rockets and other obstacles.
      It has ten different levels and a level editor to create new levels or modify the existing.
    ''; # from https://libregamewiki.org/FLTrator
    homepage = "https://fltrator.sourceforge.net/";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.marius851000 ];
    license = lib.licenses.gpl3;
  };

})
