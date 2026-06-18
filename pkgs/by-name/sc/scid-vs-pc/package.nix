{
  lib,
  fetchurl,
  tcl,
  tk,
  libx11,
  zlib,
  makeWrapper,
  which,
  makeDesktopItem,
}:

tcl.mkTclDerivation rec {
  pname = "scid-vs-pc";
  version = "4.27";

  src = fetchurl {
    url = "mirror://sourceforge/scidvspc/scid_vs_pc-${version}.tgz";
    hash = "sha256-DivCF3yCHmGyps7PTU1xKcdG+oBegD/ntMst9rOr0TU=";
  };

  postPatch = ''
    substituteInPlace configure Makefile.conf \
      --replace "~/.fonts" "$out/share/fonts/truetype/Scid" \
      --replace "which fc-cache" "false"
  '';

  nativeBuildInputs = [
    makeWrapper
    which
  ];
  buildInputs = [
    tk
    libx11
    zlib
  ];

  addTclConfigureFlags = false;
  configureFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "SHAREDIR=${placeholder "out"}/share"
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--exec-prefix=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/

    install -D icons/scid.png "$out"/share/icons/hicolor/128x128/apps/scid.png
  '';

  desktopItem = makeDesktopItem {
    name = "scid-vs-pc";
    desktopName = "Scid vs. PC";
    genericName = "Chess Database";
    comment = meta.description;
    icon = "scid";
    exec = "scid";
    categories = [
      "Game"
      "BoardGame"
    ];
  };

  meta = {
    description = "Chess database with play and training functionality";
    homepage = "https://scidvspc.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    mainProgram = "scid";
    maintainers = [ lib.maintainers.paraseba ];
    platforms = lib.platforms.linux;
  };
}
