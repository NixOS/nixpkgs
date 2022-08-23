{ stdenv
, boost
, coreutils
, cppzmq
, curl
, libepoxy
, fetchFromGitHub
, glm
, gtkmm3
, lib
, libarchive
, libgit2
, librsvg
, libspnav
, libuuid
, opencascade
, pkg-config
, podofo
, python3
, sqlite
, wrapGAppsHook
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "1vvps44n9yrzdpircl98n4061lcmwksisnf3a8xkf3qbcnixnwlp";
  };

  buildInputs = [
    cppzmq
    curl
    libepoxy
    glm
    gtkmm3
    libarchive
    libgit2
    librsvg
    libspnav
    libuuid
    opencascade
    podofo
    python3
    sqlite
    zeromq
  ];

  nativeBuildInputs = [
    boost.dev
    pkg-config
    wrapGAppsHook
  ];

  CASROOT = opencascade;

  installFlags = [
    "INSTALL=${coreutils}/bin/install"
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = "https://horizon-eda.org";
    maintainers = with maintainers; [ guserav ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
