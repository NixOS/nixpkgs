{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  pidgin,
  texLive,
  imagemagick,
  glib,
  gtk2,
}:

let
  version = "1.5.0";
in
stdenv.mkDerivation {
  pname = "pidgin-latex";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/pidgin-latex/pidgin-latex_${version}.tar.bz2";
    hash = "sha256-nIUK7pDX5Z3oNPg+CfpuPlGxI/BuJl6tcJV2CK2pVEE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    glib
    pidgin
  ];
  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -e 's/-Wl,-soname//' -i Makefile
  '';

  passthru = {
    wrapArgs = "--prefix PATH ':' ${
      lib.makeBinPath [
        texLive
        imagemagick
      ]
    }";
  };

  meta = {
    homepage = "https://sourceforge.net/projects/pidgin-latex/";
    description = "LaTeX rendering plugin for Pidgin IM";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
