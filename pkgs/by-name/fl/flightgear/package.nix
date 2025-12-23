{
  lib,
  stdenv,
  fetchFromGitLab,
  callPackage,
  libglut,
  freealut,
  libGLU,
  libGL,
  libICE,
  libjpeg,
  openal,
  plib,
  libSM,
  libunwind,
  libX11,
  xorgproto,
  libXext,
  libXi,
  libXmu,
  libXt,
  simgear,
  zlib,
  boost,
  cmake,
  libpng,
  udev,
  fltk13,
  apr,
  qt5,
  glew,
  curl,
}:

let
  version = "2024.1.3";
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchFromGitLab {
      owner = "flightgear";
      repo = "fgdata";
      tag = "${version}";
      hash = "sha256-LNHO/W8p4b8fYcehdfVecldKQ9uJp1zlg60xdgDC45c=";
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
    tag = "${version}";
    hash = "sha256-m4bbWwMXwKJrMkb6svGrIZhcsPghrTMgFs8JCx3Wn/A=";
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
    libICE
    libjpeg
    openal
    openscenegraph
    plib
    libSM
    libunwind
    libX11
    xorgproto
    libXext
    libXi
    libXmu
    libXt
    (simgear.override { openscenegraph = openscenegraph; })
    zlib
    boost
    libpng
    udev
    fltk13
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
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    license = lib.licenses.gpl2Plus;
    mainProgram = "fgfs";
  };
}
