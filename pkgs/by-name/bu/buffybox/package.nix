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
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buffybox";
  version = "3.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "dce41a6f07a2b63c3136409b7bcd0078299fadf9";
    hash = "sha256-n5RQg7kGS+lg7sRe5Defl3nDEha0vhc/FbwywD5wBsg=";
  };

  patches = [
    (fetchpatch2 {
      # This fixes a bug that might annoy you if you use something like PKCS#11
      url = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/commit/d8214b522a3cc72cd4639a1dd114103a02e9218c.patch";
      hash = "sha256-WxKuioJ1Fo5ARRYF/R4yULDVB4pq11phljzVGdWTV6s=";
    })
    (fetchpatch2 {
      # Fixes up UB
      url = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/commit/4e13c312241420cbb3e5cc7d4f0dd3e5d17449be.patch";
      hash = "sha256-7yX6gGsptwijx+ZedSJWJKhwaoBVpxIbGK+ZiMLsIhc=";
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

  meta = with lib; {
    description = "Suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
})
