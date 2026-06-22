{
  lib,
  fetchFromGitHub,
  stdenv,
  alsa-lib,
  cmake,
  copyDesktopItems,
  curl-impersonate,
  libdave,
  libopus,
  libpulseaudio,
  libsodium,
  makeDesktopItem,
  makeWrapper,
  nlohmann_json,
  pcre2,
  pkg-config,
  qt6Packages,
  voiceSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acheron";
  version = "0-unstable-2026-05-25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ouwou";
    repo = "acheron";
    rev = "06f98afe5a2703b82a4eba8236e25e993bdecb5b";
    hash = "sha256-xVduNlYGjrzwJ+UfBRJPJVBO/VZI3eeWK+SUU2LKW98=";
    fetchSubmodules = true;
    # Leave miniaudio and emoji-segmenter vendored because they are single file libraries
    # so there is little to no benefit to fetching them ourselves.
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
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
  ++ (lib.optionals voiceSupport [
    libdave
    libopus
    libsodium
  ]);

  cmakeFlags = [
    # We're not using vcpkg, so disable it.
    "-DCMAKE_TOOLCHAIN_FILE="
    "-DCURL_LIBRARY=${curl-impersonate}/lib/libcurl-impersonate.so"
  ]
  ++ lib.optional (!voiceSupport) "-DENABLE_VOICE=OFF";

  postPatch = lib.optionalString voiceSupport ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(unofficial-sodium CONFIG REQUIRED)" \
        "pkg_check_modules(sodium REQUIRED IMPORTED_TARGET libsodium)" \
      --replace-fail "find_package(Opus CONFIG REQUIRED)" \
        "pkg_check_modules(opus REQUIRED IMPORTED_TARGET opus)" \
      --replace-fail "add_subdirectory(vendor/libdave/cpp EXCLUDE_FROM_ALL)" \
        "pkg_check_modules(libdave REQUIRED IMPORTED_TARGET libdave)"

    sed -i \
      -e '/pkg_check_modules/!s|\<libdave\>|PkgConfig::libdave|' \
      -e 's|unofficial-sodium::sodium|PkgConfig::sodium|' \
      -e 's|Opus::opus|PkgConfig::opus|' \
      CMakeLists.txt
  '';

  # Upstream cmake has no install rules, so we do it ourselves.
  installPhase = ''
    runHook preInstall

    install -Dm755 acheron $out/bin/acheron

    wrapProgram $out/bin/acheron \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
        ]
      }"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      desktopName = "Acheron";
      genericName = finalAttrs.meta.description;
      startupWMClass = finalAttrs.pname;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
    })
  ];

  meta = {
    description = "Alternative Discord client with voice support made with C++ and Qt 6 Widgets";
    mainProgram = "acheron";
    homepage = "https://github.com/ouwou/acheron";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ choco98 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
