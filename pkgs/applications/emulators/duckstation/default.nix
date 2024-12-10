{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  cubeb,
  curl,
  extra-cmake-modules,
  libXrandr,
  libbacktrace,
  makeWrapper,
  ninja,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  substituteAll,
  vulkan-loader,
  wayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duckstation";
  version = "0.1-6292";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "0bc42c38aab49030118f507c9783de047769148b";
    hash = "sha256-8OavixSwEWihFY2fEdsepR1lqWlTH+//xZRKwb7lFCQ=";
  };

  patches = [
    # Tests are not built by default
    ./001-fix-test-inclusion.diff
    # Patching yet another script that fills data based on git commands...
    (substituteAll {
      src = ./002-hardcode-vars.diff;
      gitHash = finalAttrs.src.rev;
      gitBranch = "master";
      gitTag = "${finalAttrs.version}-g0bc42c38";
      gitDate = "2024-02-06T22:47:47+09:00";
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
    qtbase
    qtsvg
    qtwayland
    wayland
  ] ++ cubeb.passthru.backendLibs;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/common-tests
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
      libPath = lib.makeLibraryPath (
        [
          vulkan-loader
        ]
        ++ cubeb.passthru.backendLibs
      );
    in
    [
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
    maintainers = with lib.maintainers; [
      guibou
      AndersonTorres
    ];
    platforms = lib.platforms.linux;
  };
})
