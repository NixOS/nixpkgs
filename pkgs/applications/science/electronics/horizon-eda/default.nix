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
, opencascade-occt
, pkg-config
, podofo
, python3
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "sha256-R827l7WxyeCPQFXSzFcn4nE4AZBAOQ7s5QylDpxbw3U=";
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
    opencascade-occt
    podofo
    python3
    sqlite
  ];

  nativeBuildInputs = [
    boost.dev
    pkg-config
    wrapGAppsHook
  ];

  CASROOT = opencascade-occt;

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
