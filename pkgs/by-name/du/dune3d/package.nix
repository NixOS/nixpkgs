{
  cmake,
  eigen,
  fetchFromGitHub,
  glm,
  gobject-introspection,
  gtkmm4,
  lib,
  libepoxy,
  librsvg,
  libspnav,
  libuuid,
  meson,
  ninja,
  opencascade-occt,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "dune3d";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dune3d";
    repo = "dune3d";
    rev = "v${version}";
    hash = "sha256-y7jlqH1p2vCFTM14rFURxTkrWUT5hNkCseC3xB6bFFo=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];
  buildInputs = [
    cmake
    eigen
    glm
    gtkmm4
    libepoxy
    librsvg
    libspnav
    libuuid
    opencascade-occt
    (python3.withPackages (pp: [
      pp.pygobject3
    ]))
  ];

  env.CASROOT = opencascade-occt;

  meta = with lib; {
    description = "3D CAD application";
    homepage = "https://dune3d.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0x4A6F jue89 ];
    mainProgram = "dune3d";
    platforms = platforms.linux;
  };
}
