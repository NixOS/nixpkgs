{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, cubeb
, curl
, extra-cmake-modules
, libXrandr
, makeDesktopItem
, mesa # for libgbm
, ninja
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwayland
, vulkan-loader
, wayland
, wrapQtAppsHook
, enableWayland ? true
, libbacktrace
}:

stdenv.mkDerivation rec {
  pname = "duckstation";
  version = "unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "d5608bf12df7a7e03750cb94a08a3d7999034ae2";
    hash = "sha256-ktfZgacjkN6GQb1vLmyTZMr8QmmH12qAvFSIBTjgRSs=";
  };

  # hack to fix missing version numbers in build (help->about and titlebar).
  # src/scmversion/gen_scmversion.sh script expects to be in a git repo to generate these values.
  # sh src/scmversion/gen_scmversion.sh in duckstation git repo manually on the rev commit and edit this.

  git_hash = "${src.rev}";
  git_branch = "master";
  git_tag = "0.1-5889-gd5608bf1";
  git_date = "2023-09-30T23:20:09+10:00";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
    libbacktrace
  ]
  ++ lib.optionals enableWayland [
    extra-cmake-modules
  ];

  buildInputs = [
    SDL2
    curl
    libXrandr
    mesa
    qtbase
    qtsvg
    vulkan-loader
    libbacktrace
  ]
  ++ lib.optionals enableWayland [
    qtwayland
    wayland
  ]
  ++ cubeb.passthru.backendLibs;

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
  ]
  ++ lib.optionals enableWayland [ "-DENABLE_WAYLAND=ON" ];

  postPatch = ''
      substituteInPlace src/CMakeLists.txt \
      --replace 'add_subdirectory(common-tests EXCLUDE_FROM_ALL)' 'add_subdirectory(common-tests)'

      substituteInPlace src/scmversion/gen_scmversion.sh \
      --replace "HASH=\$(git rev-parse HEAD)" "HASH=${git_hash}" \
      --replace "BRANCH=\$(git rev-parse --abbrev-ref HEAD | tr -d '\r\n')" "BRANCH=${git_branch}" \
      --replace "TAG=\$(git describe --tags --dirty --exclude latest --exclude preview --exclude legacy --exclude previous-latest | tr -d '\r\n')" "TAG=${git_tag}" \
      --replace "DATE=\$(git log -1 --date=iso8601-strict --format=%cd)" "DATE=${git_date}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "duckstation-qt";
      desktopName = "DuckStation";
      genericName = "PlayStation 1 Emulator";
      icon = "duckstation";
      tryExec = "duckstation-qt";
      exec = "duckstation-qt %f";
      comment = "Fast PlayStation 1 emulator";
      categories = [ "Game" "Emulator" "Qt" ];
      type = "Application";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-qt $out/bin/

    install -Dm644 bin/resources/images/duck.png $out/share/pixmaps/duckstation.png

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/common-tests
    runHook postCheck
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ vulkan-loader ] ++ cubeb.passthru.backendLibs)}"
  ];

  meta = with lib; {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = licenses.gpl3Only;
    mainProgram = "duckstation-qt";
    maintainers = with maintainers; [ guibou AndersonTorres ];
    platforms = platforms.linux;
  };
}
