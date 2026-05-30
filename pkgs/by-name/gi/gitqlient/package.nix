{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  cmake,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitqlient";
  version = "1.6.3-unstable-2025-09-11"; # cmake does not install correctly on tagged release

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = "gitqlient";
    rev = "faa3e2c19205123944bb88427a569c6f1b4366a1";
    fetchSubmodules = true;
    hash = "sha256-CBgzTwJWssL0NaNqfesHkOG4pi6QQYxjxWHFcG00U0U=";
  };

  patches = [
    # fetcher removes .git directory, but cmake attempts to update submodules if .git is missing
    ./dont-attempt-submodule-update.patch
    # install logic in unstable is slightly better, but still attempts to install to source tree, not store
    ./install-to-store.patch
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations"; # QCheckBox::stateChanged is deprecated

  meta = {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "Multi-platform Git client written with Qt";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "gitqlient";
  };
})
