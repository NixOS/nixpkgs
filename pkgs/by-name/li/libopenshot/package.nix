{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  cppzmq,
  doxygen,
  ffmpeg,
  imagemagick,
  jsoncpp,
  libopenshot-audio,
  llvmPackages,
  pkg-config,
  python3,
  qt6,
  swig,
  zeromq,
  resvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot";
  version = "0.7.0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "a58565292cb84438b1c6a039c343b4c65003bd82";
    hash = "sha256-zUzyi/VydrxDLCY7E/LBr7+btthOjal3c7md6PTXQWA=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # Darwin requires both Magick++ and MagickCore for a successful linkage
    ./0001-link-magickcore.diff
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    swig
  ];

  buildInputs = [
    cppzmq
    ffmpeg
    imagemagick
    jsoncpp
    libopenshot-audio
    python3
    qt6.qtbase
    qt6.qtmultimedia
    zeromq
    resvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapQtApps = true;

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RUBY" false)
    (lib.cmakeBool "ENABLE_PYTHON" true)
    (lib.cmakeOptionType "filepath" "PYTHON_EXECUTABLE" (lib.getExe python3))
    (lib.cmakeOptionType "filepath" "PYTHON_MODULE_PATH" python3.sitePackages)
    "-DUSE_QT6=ON"
  ];

  passthru = {
    inherit libopenshot-audio;
  };

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
