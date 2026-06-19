{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  glib,
  zlib,
  curl,
  libGLX,
  libx11,
  xorg,
  fontconfig,
  pulseaudio,
  expat,
  libmpg123,
  libsndfile,
  libsysprof-capture,
  gst_all_1,
  cairo,

  headless ? false,
  disableAudio ? true,
  disableVideo ? true,

  buildTests ? true,
  buildAllSamples ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "cinder";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "cinder";
    repo = "Cinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IPF8/PQ9iWmXwwJ6MBGtkbNcpOzW8VnyMaBRxXIN6DQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals buildAllSamples [ cairo ];

  propagatedBuildInputs = [
    libGLX
    curl
    fontconfig
    zlib
    libx11
    xorg.libxcb
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    expat
  ]
  ++ lib.optionals (!disableAudio) [
    pulseaudio
    libmpg123
    libsndfile
  ]
  ++ lib.optionals (!disableVideo) [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    libsysprof-capture
  ];

  prePatch = ''
    substituteInPlace proj/cmake/modules/FindMPG123.cmake \
      --replace-fail "NO_DEFAULT_PATH" ""

    substituteInPlace proj/cmake/modules/FindSNDFILE.cmake \
      --replace-fail "NO_DEFAULT_PATH" ""
  '';

  patches = [
    (fetchpatch {
      # TODO: Remove when [https://github.com/cinder/Cinder/pull/2386] get merged
      name = "001-fixDisableVideo";
      url = "https://github.com/cinder/Cinder/commit/94230d6dd42305c3f404a8fafd4f0fb1934349fa.patch";
      hash = "sha256-xEWv/Zp6wMvxAOAy0BFPadhHlDGL95DrvDh9n/KRUIs=";
    })
    (fetchpatch {
      name = "002-fixTimelineSamples";
      url = "https://github.com/cinder/Cinder/commit/c7530ef4f2161be8e9e9fb4b4cafae6521272dc4.patch";
      hash = "sha256-m5duVHNEmefy3mWbFXo6xBtUAOMaEkpednmNmH0JR+Y=";
    })
  ];

  postPatch = lib.optionalString buildAllSamples ''
    # Windows-specific samples
    rm -rf samples/D3d11*
    rm -rf samples/_opengl/NvidiaMulticast

    # They don't work cause of missing blocks for Linux
    rm -rf samples/LocationManager
    rm -rf samples/MotionBasic

    rm -rf samples/QuickTime*
    rm -rf samples/ios*

    rm -rf samples/Renderer2dBasic
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optionals headless [ "-DCINDER_HEADLESS=ON" ]
  ++ lib.optionals disableVideo [ "-DCINDER_DISABLE_VIDEO=ON" ]
  ++ lib.optionals disableAudio [ "-DCINDER_DISABLE_AUDIO=ON" ]
  ++ lib.optionals buildTests [ "-DCINDER_BUILD_TESTS=ON" ]
  ++ lib.optionals buildAllSamples [ "-DCINDER_BUILD_ALL_SAMPLES=ON" ];

  doCheck = buildTests;

  installPhase = ''
    runHook preInstall

    mkdir $out

    mkdir -p $out/include/cinder
    mkdir -p $out/lib/cmake/Cinder

    cp -r ../include/cinder/* $out/include/cinder

    find .. -name "libcinder.*" -exec cp {} $out/lib/ \;

    find lib -name "cinderTargets.cmake" -exec cp {} $out/lib/cmake/Cinder/ \;

    ${lib.optionalString buildAllSamples ''
      mkdir -p $out/Samples
      mkdir -p $out/bin

      cp -Lr Release/* $out/Samples
      rm -r $out/Samples/UnitTests

      for dir in $out/Samples/*/; do
        for file in "$dir"/*; do
            [[ -x "$file" ]] && [[ -f "$file" ]] \
              && ln -s $file $out/bin/cinder_$(basename "$file")
        done
      done
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Peer-reviewed, free, open source C++ library for creative coding";
    homepage = "https://libcinder.org";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GiulioCocconi ];
  };
})
