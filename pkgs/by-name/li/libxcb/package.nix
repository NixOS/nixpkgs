{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  libpthread-stubs,
  libxau,
  libxdmcp,
  xcb-proto,
  windows,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb";
  version = "1.17.0";

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libxcb-${finalAttrs.version}.tar.xz";
    hash = "sha256-WZ6/mZZxD+pxYi5uGE86itW0PQ5fqMTkBxI8iKWabVU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libpthread-stubs
    libxau
    libxdmcp
    xcb-proto
  ];

  # $dev/include/xcb/xcb.h includes pthread.h
  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isMinGW {
    NIX_CFLAGS_COMPILE = toString [ "-Wno-incompatible-pointer-types" ];
  };

  meta = {
    description = "C interface to the X Window System protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb";
    # gitlab wrongly says X11 Distribute Modifications
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [
      "xcb"
      "xcb-composite"
      "xcb-damage"
      "xcb-dpms"
      "xcb-dri2"
      "xcb-dri3"
      "xcb-glx"
      "xcb-present"
      "xcb-randr"
      "xcb-record"
      "xcb-render"
      "xcb-res"
      "xcb-screensaver"
      "xcb-shape"
      "xcb-shm"
      "xcb-sync"
      "xcb-xf86dri"
      "xcb-xfixes"
      "xcb-xinerama"
      "xcb-xinput"
      "xcb-xkb"
      "xcb-xtest"
      "xcb-xv"
      "xcb-xvmc"
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
