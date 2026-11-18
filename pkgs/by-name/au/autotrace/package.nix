{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  gettext,
  intltool,
  pkg-config,
  glib,
  imagemagick,
  libpng,
  pstoedit,
}:

stdenv.mkDerivation rec {
  pname = "autotrace";
  version = "0.31.11";

  src = fetchFromGitHub {
    owner = "autotrace";
    repo = "autotrace";
    tag = version;
    hash = "sha256-M4a+/RbuAfH7i7Dbo8YA0I34VhChSu6UbM3a0aUj5qw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    pkg-config
  ];

  buildInputs = [
    glib
    imagemagick
    libpng
    pstoedit
  ];

  meta = {
    homepage = "https://github.com/autotrace/autotrace";
    description = "Utility for converting bitmap into vector graphics";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.gpl2;
    mainProgram = "autotrace";
  };
}
