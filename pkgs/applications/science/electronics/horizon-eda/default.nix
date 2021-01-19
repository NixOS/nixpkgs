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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "13c4p60vrmwmnrv2jcr2gc1cxnimy7j8yp1p6434pbbk2py9k8mx";
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
