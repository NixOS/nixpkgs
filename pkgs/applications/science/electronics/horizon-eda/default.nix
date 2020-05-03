{ stdenv
, lib
, fetchFromGitHub
, pkgconfig
, sqlite
, libyamlcpp
, libuuid
, gnome3
, epoxy
, librsvg
, zeromq
, cppzmq
, glm
, libgit2
, curl
, boost
, python3
, opencascade
, libzip
, podofo
, wrapGAppsHook
, coreutils }:

stdenv.mkDerivation rec {
  pname = "horizon-eda";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "horizon-eda";
    repo = "horizon";
    rev = "v${version}";
    sha256 = "sha256-gfCD//eiW7zmvVSeIVWos34lOTHqef0k96i4lJ1EzSg=";
  };

  buildInputs = [
    boost
    cppzmq
    curl
    epoxy
    glm
    gnome3.gtkmm
    libgit2
    librsvg
    libuuid
    libyamlcpp
    libzip
    opencascade
    podofo
    python3
    sqlite
    zeromq
  ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  NIX_CFLAGS_COMPILE = "-I${opencascade}/include/oce";

  installPhase = ''
    make install INSTALL=${coreutils}/bin/install DESTDIR=$out PREFIX=
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = "https://github.com/horizon-eda/horizon";
    maintainers = with maintainers; [ luz yrashk ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
