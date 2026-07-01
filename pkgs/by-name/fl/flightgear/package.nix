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
  openscenegraph = callPackage ./openscenegraph-flightgear.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flightgear";
  version = "2024.1.6";

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "flightgear";
    tag = finalAttrs.version;
    hash = "sha256-unYP8q7IvNwjLHTmm/38gauCPxr3+ZFcsD5rY6BEzno=";
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

  qtWrapperArgs = [ "--set FG_ROOT ${finalAttrs.passthru.data}/share/FlightGear" ];

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

  passthru = {
    updateScript = nix-update-script { };

    data = stdenv.mkDerivation {
      pname = "flightgear-data";
      inherit (finalAttrs) version;

      src = fetchFromGitLab {
        owner = "flightgear";
        repo = "fgdata";
        tag = finalAttrs.version;
        hash = "sha256-B7WCEMrHtSW4Yk2HM+ZjgKt5GeQrSmvxKITqAYXKSuw=";
      };

      dontUnpack = true;

      installPhase = ''
        mkdir -p "$out/share/FlightGear"
        cp -a "$src"/* "$out/share/FlightGear/"
      '';
    };
  };

  meta = {
    description = "A free and highly sophisticated flight simulator";
    homepage = "https://www.flightgear.org/";
    changelog = "https://www.flightgear.org/download/releases/2024-1-5"; # TODO: Use finalattrs when back on stable tracking
    maintainers = with lib.maintainers; [
      raskin
      kirillrdy
      philocalyst
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    license = lib.licenses.gpl2Plus;
    mainProgram = "fgfs";
  };
})
