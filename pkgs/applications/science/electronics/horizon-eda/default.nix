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
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-UcjbDJR6shyETpanNkRoH8LF8r6gFjsyNHVSCMHKqS8=";
=======
    sha256 = "sha256-R827l7WxyeCPQFXSzFcn4nE4AZBAOQ7s5QylDpxbw3U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
