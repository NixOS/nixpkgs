{ stdenv
, boost
, coreutils
, cppzmq
, curl
, epoxy
, fetchFromGitHub
, glm
, gnome3
, lib
, libgit2
, librsvg
, libuuid
, libzip
, opencascade
, pkgconfig
, podofo
, python3
, sqlite
, wrapGAppsHook
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "0b1bi99xdhbkb2vdb9y6kyqm0h8y0q168jf2xi8kd0z7kww8li2p";
  };

  buildInputs = [
    cppzmq
    curl
    epoxy
    glm
    gnome3.gtkmm
    libgit2
    librsvg
    libuuid
    libzip
    opencascade
    podofo
    python3
    sqlite
    zeromq
  ];

  nativeBuildInputs = [
    boost.dev
    pkgconfig
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
