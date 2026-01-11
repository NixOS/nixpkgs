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
  version = "0.31.10";

  src = fetchFromGitHub {
    owner = "autotrace";
    repo = "autotrace";
    tag = version;
    hash = "sha256-PbEK5+7jcYIwYmgxBIOpNyj2KJNPfqKBKb+wYwoLKSo=";
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
    maintainers = with lib.maintainers; [ hodapp ];
    license = lib.licenses.gpl2;
    mainProgram = "autotrace";
  };
}
