{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, gettext
, intltool
, pkg-config
, glib
, imagemagick
, libpng
, pstoedit
, darwin
}:

stdenv.mkDerivation rec {
  pname = "autotrace";
  version = "0.31.9";

  src = fetchFromGitHub {
    owner = "autotrace";
    repo = "autotrace";
    rev = version;
    hash = "sha256-8qqB6oKmbz95dNLtdLvb69cEj/P7TzdoKEyJ8+4ITzs=";
  };

  patches = [
    (fetchpatch {
      name = "imagemagick7-support.patch";
      url = "https://github.com/autotrace/autotrace/pull/105.patch";
      hash = "sha256-Q82LRF/BsJ/Ii2s+7yaYHs9agMKYVYIMnbwqz8P92s0=";
    })
  ];

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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    homepage = "https://github.com/autotrace/autotrace";
    description = "Utility for converting bitmap into vector graphics";
    platforms = platforms.unix;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.gpl2;
  };
}
