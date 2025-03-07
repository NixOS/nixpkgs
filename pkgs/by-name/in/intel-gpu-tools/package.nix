{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,

  # build time
  bison,
  docbook_xsl,
  docutils,
  flex,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  utilmacros,

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
  libX11,
  libXext,
  libXrandr,
  libXv,
  openssl,
  peg,
  procps,
  python3,
  udev,
  valgrind,
  xmlrpc_c,
  xorgproto,
}:

stdenv.mkDerivation rec {
  pname = "intel-gpu-tools";
  version = "1.30";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "drm";
    repo = "igt-gpu-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-lZNDDWfySz7etxzN/28bo9qDE8SxK2vPAAOR3hxSoWY=";
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
    utilmacros
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
    libX11
    libXext
    libXrandr
    libXv
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

  meta = with lib; {
    changelog = "https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/v${version}/NEWS";
    homepage = "https://drm.pages.freedesktop.org/igt-gpu-tools/";
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ pSub ];
  };
}
