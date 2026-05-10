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
  xz,
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
  nix-update-script,
}:

let
  version = "2024.1.5";
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchFromGitLab {
      owner = "flightgear";
      repo = "fgdata";
      tag = version;
      hash = "sha256-8B5wSYjkWuPEySpqBiprZ+jrHy01HA9+iX70wNAn81s=";
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
    hash = "sha256-sORiO0SDChIVWIhGKelm7IE/cZ40gMqlZ1OoZZna7kI=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    freealut
    libjpeg
    openal
    plib
    (simgear.override { openscenegraph = openscenegraph; })
    zlib
    boost
    libpng
    fltk_1_3
    apr
    qt5.qtbase
    qt5.qtquickcontrols2
    glew
    qt5.qtdeclarative
    curl
    openscenegraph
    xz
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libglut
    libGLU
    libGL
    libice
    libsm
    libunwind
    libx11
    xorgproto
    libxext
    libxi
    libxmu
    libxt
    udev
  ];

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin (
    lib.cmakeFeature "CMAKE_OSX_DEPLOYMENT_TARGET" "11.0"
  );

  qtWrapperArgs = [ "--set FG_ROOT ${data}/share/FlightGear" ];

  postInstall = ''
    # Remove redundant AppImage artifacts
    rm -rf "$out/appdir"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The bundle copies OSG dylib dangling symlinks
    rm -rf "$out/FlightGear.app/Contents/Frameworks"
    # Place app bundle where macOS expects it
    mkdir -p "$out/Applications"
    mv "$out/FlightGear.app" "$out/Applications/"
    # Provide fgfs in bin/ for CLI use, pointing into the bundle
    ln -s "$out/Applications/FlightGear.app/Contents/MacOS/FlightGear" "$out/bin/fgfs"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flight simulator";
    maintainers = with lib.maintainers; [
      raskin
      kirillrdy
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    license = lib.licenses.gpl2Plus;
    mainProgram = "fgfs";
  };
}
