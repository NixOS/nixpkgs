{
  fetchFromGitLab,
  inih,
  lib,
  libdrm,
  libinput,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffybox";
  version = "3.4.2-unstable-2025-10-25";
  # 3.4.2 would be preferred but there are 3 commits past 3.4.2 that are really nice to have

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "437ff2cbd7fd35ba6ca2d46624e7fcf8c5f3f954";
    hash = "sha256-1GRsntNc3byHmZKLG/ZRXvbo96DjmLrA0bVYtMAlKsQ=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    inih
    libdrm
    libinput
    libxkbcommon
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMD_SYSTEM_UNIT_DIR = "${placeholder "out"}/lib/systemd/system";

  strictDeps = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
})
