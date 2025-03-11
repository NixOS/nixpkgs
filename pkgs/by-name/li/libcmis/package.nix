{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  libxml2,
  pkg-config,
  docbook2x,
  curl,
  autoreconfHook,
  cppunit,
}:

stdenv.mkDerivation rec {
  pname = "libcmis";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "tdf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HXiyQKjOlQXWABY10XrOiYxPqfpmUJC3a6xD98LIHDw=";
  };

  patches = [
    # Backport to fix build with boost 1.86
    (fetchpatch {
      url = "https://github.com/tdf/libcmis/commit/3659d32999ff7593662dcf5136bcb7ac15c13f61.patch";
      hash = "sha256-EXmQcXCHaVnF/dwU3Z4WLtaiHjYHeeonlKdyK27UkiY=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    docbook2x
  ];
  buildInputs = [
    boost
    libxml2
    curl
    cppunit
  ];

  configureFlags = [
    "--disable-werror"
    "DOCBOOK2MAN=${docbook2x}/bin/docbook2man"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C++ client library for the CMIS interface";
    homepage = "https://github.com/tdf/libcmis";
    license = licenses.gpl2;
    mainProgram = "cmis-client";
    platforms = platforms.unix;
  };
}
