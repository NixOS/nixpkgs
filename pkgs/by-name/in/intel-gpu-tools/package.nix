{
  lib,
  stdenv,
  fetchFromGitLab,

  # build time
  bison,
  docbook_xsl,
  docutils,
  flex,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  util-macros,

  # runtime
  alsa-lib,
  cairo,
  curl,
  elfutils,
  glib,
  gsl,
  json_c,
  kmod,
  libdrm,
  liboping,
  libpciaccess,
  libunwind,
  libx11,
  libxext,
  libxrandr,
  libxv,
  openssl,
  peg,
  procps,
  python3,
  udev,
  valgrind,
  xmlrpc_c,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-gpu-tools";
  version = "2.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "drm";
    repo = "igt-gpu-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CkVBImPPM93Q2SVpKzRAREd7cK+SmUgySiuq3LfO2O8=";
  };

  nativeBuildInputs = [
    bison
    docbook_xsl
    docutils
    flex
    gtk-doc
    meson
    ninja
    pkg-config
    util-macros
  ];

  buildInputs = [
    alsa-lib
    cairo
    curl
    elfutils
    glib
    gsl
    json_c
    kmod
    libdrm
    liboping
    libpciaccess
    libunwind
    libx11
    libxext
    libxrandr
    libxv
    openssl
    peg
    procps
    python3
    udev
    valgrind
    xmlrpc_c
    xorgproto
  ];

  preConfigure = ''
    patchShebangs lib man scripts tests
  '';

  hardeningDisable = [ "bindnow" ];

  meta = {
    changelog = "https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/v${finalAttrs.version}/NEWS";
    homepage = "https://drm.pages.freedesktop.org/igt-gpu-tools/";
    description = "Tools for development and testing of the Intel DRM driver";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [
      pSub
      ilkecan
    ];
  };
})
