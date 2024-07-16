{
  cmake,
  desktopToDarwinBundle,
  eigen,
  fetchFromGitHub,
  glm,
  gobject-introspection,
  gtkmm4,
  lib,
  libepoxy,
  libossp_uuid,
  librsvg,
  libspnav,
  libuuid,
  libxml2,
  llvmPackages_17,
  meson,
  ninja,
  opencascade-occt_7_6,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook3,
}:

let
  stdenv' = if stdenv.isDarwin then llvmPackages_17.stdenv else stdenv;
  opencascade-occt = opencascade-occt_7_6;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "dune3d";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dune3d";
    repo = "dune3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z/kdOc/MbnnEyRsel3aZGndTAy1eCdAK0Wdta0HxaE4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    libxml2 # for xmllints
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    cmake
    eigen
    glm
    gtkmm4
    libepoxy
    librsvg
    libspnav
    (if stdenv.isLinux then libuuid else libossp_uuid)
    opencascade-occt
    (python3.withPackages (pp: [
      pp.pygobject3
    ]))
  ];

  env.CASROOT = opencascade-occt;

  meta = {
    description = "3D CAD application";
    homepage = "https://dune3d.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _0x4A6F jue89 ];
    mainProgram = "dune3d";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
