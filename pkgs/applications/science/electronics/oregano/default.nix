{ fetchFromGitHub
, glib
, goocanvas2
, gnucap
, groff
, gtk3
, gtksourceview
, intltool
, libxml2
, lib
, makeWrapper
, ngspice
, perl
, pkg-config
, python3
, stdenv
, wafHook
, wrapGAppsHook
, useNgspice ? false
}:
let
  version = "0.84.43";
in
stdenv.mkDerivation {
  pname = "oregano";
  inherit version;

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = "oregano";
    rev = "v${version}";
    hash = "sha256-1GsL0N3O0clqdgkXoPKMhvW+y4Rzg4QSeOA54nH4kz4=";
  };

  patches = [ ./check-cfg-gio-unix.patch ];

  buildInputs = [
    glib
    goocanvas2
    gtk3
    gtksourceview
    libxml2
  ];

  nativeBuildInputs = [
    groff
    intltool
    makeWrapper
    wafHook
    perl
    pkg-config
    python3
    wrapGAppsHook
  ];

  postFixup = ''
    wrapProgram $out/bin/oregano \
      --suffix PATH : ${lib.makeBinPath [ (if useNgspice then ngspice else gnucap) ]}
  '';

  meta = with lib; {
    description = "Schematic capture and circuit simulator";
    longDescription = ''
      Oregano is an application for schematic capture and simulation of
      electronic circuits. The actual simulation is performed by Berkeley
      Spice, GNUcap or the new generation ngspice.
    '';

    homepage = "https://github.com/drahnr/oregano/";
    license = licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ _3442 ];
  };
}
