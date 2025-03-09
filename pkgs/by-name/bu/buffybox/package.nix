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
  version = "3.2.0-unstable-2025-02-27";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "6bf7a8406f3a3fa79831d2d151e519b703b9e135";
    hash = "sha256-q3TNYRv5Cim+WklXw2ZTW6Ico1h8Xxs9MhTFhHZUMW0=";
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
