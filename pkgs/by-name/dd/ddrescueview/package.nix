{
  stdenv,
  lib,
  fetchurl,
  fpc,
  lazarus,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk2,
  libx11,
  pango,
}:

stdenv.mkDerivation rec {
  pname = "ddrescueview";
  version = "0.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/ddrescueview/ddrescueview-source-${version}.tar.xz";
    sha256 = "sha256-Vzg8OU5iYSzip5lDiwDG48Rlwx+bqUDgd/Yk4ucChGU=";
  };
  sourceRoot = "ddrescueview-source-${version}/source";

  nativeBuildInputs = [
    fpc
    lazarus
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk2
    libx11
    pango
  ];

  env.NIX_LDFLAGS = toString [
    "--as-needed"
    "-rpath"
    (lib.makeLibraryPath buildInputs)
  ];

  buildPhase = ''
    lazbuild --lazarusdir=${lazarus}/share/lazarus ddrescueview.lpi
  '';

  installPhase = ''
    install -Dt $out/bin ddrescueview
    cd ../resources/linux
    mkdir -p "$out/share"
    cp -ar applications icons man $out/share
  '';

  meta = {
    description = "Tool to graphically examine ddrescue mapfiles";
    homepage = "https://sourceforge.net/projects/ddrescueview/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "ddrescueview";
  };
}
