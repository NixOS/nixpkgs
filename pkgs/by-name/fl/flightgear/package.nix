{
  lib,
  stdenv,
  fetchFromGitLab,
  callPackage,
  libglut,
  freealut,
  libGLU,
  libGL,
  libice,
  libjpeg,
  openal,
  plib,
  libsm,
  libunwind,
  libx11,
  xorgproto,
  libxext,
  libxi,
  libxmu,
  libxt,
  simgear,
  zlib,
  boost,
  cmake,
  libpng,
  udev,
  fltk_1_3,
  apr,
  qt5,
  glew,
  curl,
}:

let
  version = "2024.1.4";
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchFromGitLab {
      owner = "flightgear";
      repo = "fgdata";
      tag = version;
      hash = "sha256-0cIOyQhw/+jqwO1OddBC09ZnvrmtyjSoMhcu1tuwx4k=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/share/FlightGear"
      cp ${src}/* -a "$out/share/FlightGear/"
    '';
  };
  openscenegraph = callPackage ./openscenegraph-flightgear.nix { };
in
stdenv.mkDerivation rec {
  pname = "flightgear";
  # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
  inherit version data;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "flightgear";
    tag = version;
    hash = "sha256-s897bsHsVP0OAcrwDVRTPz3YNJkynyErJpH18oLPl3Y=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    libglut
    freealut
    libGLU
    libGL
    libice
    libjpeg
    openal
    openscenegraph
    plib
    libsm
    libunwind
    libx11
    xorgproto
    libxext
    libxi
    libxmu
    libxt
    (simgear.override { openscenegraph = openscenegraph; })
    zlib
    boost
    libpng
    udev
    fltk_1_3
    apr
    qt5.qtbase
    qt5.qtquickcontrols2
    glew
    qt5.qtdeclarative
    curl
  ];

  qtWrapperArgs = [ "--set FG_ROOT ${data}/share/FlightGear" ];

  postInstall = ''
    # Remove redundant AppImage artifacts
    rm -rf "$out/appdir"
  '';

  meta = {
    description = "Flight simulator";
    maintainers = with lib.maintainers; [
      raskin
      kirillrdy
    ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    license = lib.licenses.gpl2Plus;
    mainProgram = "fgfs";
  };
}
