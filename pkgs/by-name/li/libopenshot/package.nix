{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  catch2_3,
  cmake,
  cppzmq,
  ctestCheckHook,
  doxygen,
  # FIXME: unpin when libopenshot supports ffmpeg 9 (AVCodec.{pix_fmts,sample_fmts,...} removed)
  ffmpeg_8,
  glib,
  imagemagick,
  jsoncpp,
  libopenshot-audio,
  llvmPackages,
  nix-update-script,
  opencv4,
  pipewire,
  pkg-config,
  protobuf,
  python3,
  qt6,
  swig,
  zeromq,
  resvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OSyBuvprhkGMfpSeEPR7FccBgb+9y0jCuNDrAXhs/0M=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(CMAKE_CXX_STANDARD 17)" "set(CMAKE_CXX_STANDARD 20)"
    sed -i 's/\blerp(/lerp_(/g' src/effects/{AnalogTape,DenoiseImage,FilmGrain}.cpp
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    protobuf
    swig
  ];

  buildInputs = [
    catch2_3
    cppzmq
    ffmpeg_8
    imagemagick
    jsoncpp
    libopenshot-audio
    (opencv4.override { ffmpeg_8-headless = ffmpeg_8; })
    protobuf
    python3
    qt6.qtbase
    qt6.qtmultimedia
    zeromq
    resvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    glib
    pipewire
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapQtApps = true;

  doCheck = true;

  nativeCheckInputs = [ ctestCheckHook ];

  # Spherical metadata is not round-tripped when writing/reading with FFmpeg 8
  ctestFlags = [
    "--exclude-regex"
    "^SphericalMetadata"
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RUBY" false)
    (lib.cmakeBool "ENABLE_PYTHON" true)
    (lib.cmakeOptionType "filepath" "PYTHON_EXECUTABLE" (lib.getExe python3))
    (lib.cmakeOptionType "filepath" "PYTHON_MODULE_PATH" python3.sitePackages)
    "-DUSE_QT6=ON"
  ];

  passthru = {
    inherit libopenshot-audio;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "http://openshot.org/";
    changelog = "https://github.com/OpenShot/libopenshot/releases/tag/v${finalAttrs.version}";
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
