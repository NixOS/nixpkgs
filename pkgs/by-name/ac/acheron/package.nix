{
  lib,
  fetchFromGitHub,
  stdenv,
  alsa-lib,
  cmake,
  curl-impersonate,
  ffmpeg-headless,
  libdave,
  libopus,
  libpulseaudio,
  libsodium,
  makeWrapper,
  nlohmann_json,
  pcre2,
  pkg-config,
  qt6Packages,
  rnnoise,
  voiceSupport ? true,
  videoSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acheron";
  version = "0-unstable-2026-08-28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ouwou";
    repo = "acheron";
    rev = "fb08e68bf98978fa34aca4bbf576f5476e69fc7c";
    hash = "sha256-L4aAgw8F2E+Tysov7UjCt6X1NY6pZDOHUcj1CNSYntw=";
    fetchSubmodules = true;
    # Leave miniaudio and emoji-segmenter vendored because they are single file libraries
    # so there is little to no benefit to fetching them ourselves.
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    curl-impersonate
    nlohmann_json
    pcre2
    qt6Packages.qtbase
    qt6Packages.qtimageformats
    qt6Packages.qtkeychain
    qt6Packages.qttools
  ]
  ++ lib.optionals voiceSupport [
    libdave
    libopus
    libsodium
    rnnoise
  ]
  ++ lib.optionals videoSupport [ ffmpeg-headless ];

  cmakeFlags = [
    "-DUSE_VCPKG=OFF"
    "-DCURL_LIBRARY=${curl-impersonate}/lib/libcurl-impersonate.so"
  ]
  ++ lib.optional (!voiceSupport) "-DENABLE_VOICE=OFF"
  ++ lib.optional (!videoSupport) "-DENABLE_FFMPEG=OFF";

  postPatch = lib.optionalString voiceSupport ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(vendor/libdave/cpp EXCLUDE_FROM_ALL)" \
        "pkg_check_modules(libdave REQUIRED IMPORTED_TARGET libdave)"
    sed -i \
      -e '/pkg_check_modules/!s|\<libdave\>|PkgConfig::libdave|' \
      CMakeLists.txt
  '';

  # Required as acheron uses bundled miniaudio.h for audio
  postFixup = ''
    wrapProgram $out/bin/acheron \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
        ]
      }"
  '';

  meta = {
    description = "Alternative Discord client with voice support made with C++ and Qt 6 Widgets";
    mainProgram = "acheron";
    homepage = "https://github.com/ouwou/acheron";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ choco98 ];
    platforms = lib.platforms.linux;
  };
})
