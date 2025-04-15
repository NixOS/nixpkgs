{
  fetchFromGitLab,
  fetchpatch2,
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
  version = "3.2.0-unstable-2025-03-16";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "56a9867e90ece88596e330774da64cf277069b59";
    hash = "sha256-4lSgswcvvV6W1KN6QhsjeHY8MMXXC4fRYBmPE/hb0vA=";
  };

  patches = [
    (fetchpatch2 {
      # https://gitlab.postmarketos.org/postmarketOS/buffybox/-/merge_requests/42
      url = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/commit/1f0c30e88dc61b8b508696cd890393c3b7911b58.patch?full_index=1";
      hash = "sha256-hQ6Hjfyj059j2cRfrFz9Se6xRowIGW1HVHULLYtHcS8=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
})
