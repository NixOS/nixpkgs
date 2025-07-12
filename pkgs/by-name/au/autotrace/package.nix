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

  meta = with lib; {
    homepage = "https://github.com/autotrace/autotrace";
    description = "Utility for converting bitmap into vector graphics";
    platforms = platforms.unix;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.gpl2;
    mainProgram = "autotrace";
  };
}
