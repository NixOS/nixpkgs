{
  fetchFromGitLab,
  fetchpatch,
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
  version = "3.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    tag = finalAttrs.version;
    hash = "sha256-aOPfKqnUIkJozt+DwVJjbNQEcmpjCmUgJUjTx9LV23M=";
  };

  mesonFlags = [
    (lib.mesonBool "systemd" true)
  ];

  patches = [
    /*
      There's a close to zero chance that anyone with a 32-bit machine will be using BuffyBox.
      In the case that it happens, I expect no complaints whatsoever.

      https://gitlab.postmarketos.org/postmarketOS/buffybox/-/merge_requests/87
    */

    (fetchpatch {
      name = "fix-32-bit-build";
      url = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/merge_requests/87.patch";
      hash = "sha256-GUk+YrG07hL+0w70qvymPzHGTmUXdfzG4Cy35gg/Asw=";
    })
  ];

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

  meta = {
    description = "Suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    changelog = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
  };
})
