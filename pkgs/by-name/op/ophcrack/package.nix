{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, libtool
, zlib
, openssl
, freetype
, fontconfig
, libpthreadstubs
, gcc
, makeWrapper
, pkg-config
, expat
, qtcharts
, qtbase
, wrapQtAppsHook
, cmake
}:

stdenv.mkDerivation rec {
  pname = "ophcrack";
  version = "3.8.0-3";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "pkg-security-team";
    repo = "ophcrack";
    rev = "debian/${version}";
    hash = "sha256-94zEr7aBeqMjy5Ma50W3qv1S5yx090bYuTieoZaXFcc=";
  };

 nativeBuildInputs = [ autoreconfHook libtool wrapQtAppsHook ];

 buildInputs = [ pkg-config zlib openssl freetype fontconfig libpthreadstubs gcc expat qtcharts ];

 configPhase = ''
   CFLAGS="-I/usr/include/libxml2/libxml/"
    ./config
 '';

 buildPhase = ''
   make
 '';

 installPhase = ''
   make install
 '';

  meta = with lib; {
    description = "Ophcrack packaging";
    homepage = "https://salsa.debian.org/pkg-security-team/ophcrack";
    changelog = "https://salsa.debian.org/pkg-security-team/ophcrack/-/blob/${src.rev}/ChangeLog";
    license = with licenses; [ openssl gpl2Only ];
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "ophcrack";
    platforms = platforms.all;
  };
}
