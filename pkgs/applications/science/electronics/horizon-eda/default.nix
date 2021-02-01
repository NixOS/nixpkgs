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
, pkg-config
, podofo
, python3
, sqlite
, wrapGAppsHook
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "0mra6kf1c2qixfzqva6r01qms5kdabbhhblhk5is6h6nq78i8640";
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
