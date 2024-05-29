{ lib
, stdenv
, fetchFromGitHub
, SDL2
, callPackage
, cmake
, cubeb
, curl
, extra-cmake-modules
, libXrandr
, libbacktrace
, libwebp
, makeWrapper
, ninja
, pkg-config
, qt6
, substituteAll
, vulkan-loader
, wayland
}:

let
  shaderc-patched = callPackage ./shaderc-patched.nix { };
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
  ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckstation";
  version = "0.1-6658";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "4e0c417add264226b3db065c1466791f0591a1b5";
    hash = "sha256-fN0bcjqjMmK3qVLlrYmR2VgjK0BjdK4nUj8vNYdFC3I=";
  };

  patches = [
    # Tests are not built by default
    ./001-fix-test-inclusion.diff
    # Patching yet another script that fills data based on git commands...
    (substituteAll {
      src = ./002-hardcode-vars.diff;
      gitHash = finalAttrs.src.rev;
      gitBranch = "master";
      gitTag = "${finalAttrs.version}-g4e0c417a";
      gitDate = "2024-04-16T12:49:54+10:00";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    curl
    libXrandr
    libbacktrace
    libwebp
    qtbase
    qtsvg
    qtwayland
    shaderc-patched
    wayland
  ]
  ++ cubeb.passthru.backendLibs;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preCheck

    $out/share/duckstation/common-tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-qt $out/bin/

    install -Dm644 $src/scripts/org.duckstation.DuckStation.desktop $out/share/applications/org.duckstation.DuckStation.desktop
    install -Dm644 $src/scripts/org.duckstation.DuckStation.png $out/share/pixmaps/org.duckstation.DuckStation.png

    runHook postInstall
  '';

  qtWrapperArgs =
    let
      libPath = lib.makeLibraryPath ([
        vulkan-loader
      ] ++ cubeb.passthru.backendLibs);
    in [
      "--prefix LD_LIBRARY_PATH : ${libPath}"
    ];

  # https://github.com/stenzek/duckstation/blob/master/scripts/appimage/apprun-hooks/default-to-x11.sh
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/duckstation-qt \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
  '';

  meta = {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = lib.licenses.gpl3Only;
    mainProgram = "duckstation-qt";
    maintainers = with lib.maintainers; [ guibou AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
