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
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffybox";
  version = "3.2.0-unstable-2024-11-10";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "07e324c17564cb9aab573259a8e0824a6806a751";
    hash = "sha256-JY9WqtRjDsQf1UVFnM6oTwyAuhlJvrhcSNJdEZ0zIus=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
})
