{ lib
, stdenv
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
, vulkan-loader
, wayland
}:

let
  sources = callPackage ./sources.nix { };
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
  ;
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sources.duckstation) pname version src;

  patches = [
    # Tests are not built by default
    ./001-fix-test-inclusion.diff
    # Patching yet another script that fills data based on git commands . . .
    ./002-hardcode-vars.diff
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    curl
    extra-cmake-modules
    libXrandr
    libbacktrace
    libwebp
    qtbase
    qtsvg
    qtwayland
    sources.shaderc-patched
    wayland
  ]
  ++ cubeb.passthru.backendLibs;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  strictDeps = true;

  doInstallCheck = true;

  postPatch = ''
    gitHash=$(cat .nixpkgs-auxfiles/git_hash) \
    gitBranch=$(cat .nixpkgs-auxfiles/git_branch) \
    gitTag=$(cat .nixpkgs-auxfiles/git_tag) \
    gitDate=$(cat .nixpkgs-auxfiles/git_date) \
      substituteAllInPlace src/scmversion/gen_scmversion.sh
  '';

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
