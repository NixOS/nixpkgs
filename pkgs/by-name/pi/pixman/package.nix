{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libpng,
  glib, # just passthru

  # for passthru.tests
  cairo,
  qemu,
  scribus,
  tigervnc,
  wlroots_0_17,
  wlroots_0_18,
  xwayland,

  gitUpdater,
  testers,

  __flattenIncludeHackHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pixman";
  version = "0.43.4";

  src = fetchurl {
    urls = with finalAttrs; [
      "mirror://xorg/individual/lib/${pname}-${version}.tar.gz"
      "https://cairographics.org/releases/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-oGJNuQGAx923n8epFRCT3DfGRtjDjT8jL3Z89kuFoiY=";
  };

  # Raise test timeout, 120s can be slightly exceeded on slower hardware
  postPatch = ''
    substituteInPlace test/meson.build \
      --replace-fail 'timeout : 120' 'timeout : 240'
  '';

  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    __flattenIncludeHackHook
  ];

  buildInputs = [ libpng ];

  # Default "enabled" value attempts to enable CPU features on all
  # architectures and requires used to disable them:
  #   https://gitlab.freedesktop.org/pixman/pixman/-/issues/88
  mesonAutoFeatures = "auto";
  mesonFlags =
    [
      "-Diwmmxt=disabled"
    ]
    # Disable until https://gitlab.freedesktop.org/pixman/pixman/-/issues/46 is resolved
    ++ lib.optional (stdenv.hostPlatform.isAarch64 && !stdenv.cc.isGNU) "-Da64-neon=disabled";

  preConfigure = ''
    # https://gitlab.freedesktop.org/pixman/pixman/-/issues/62
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 184 ? 184 : NIX_BUILD_CORES))
  '';

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    tests = {
      inherit
        cairo
        qemu
        scribus
        tigervnc
        wlroots_0_17
        wlroots_0_18
        xwayland
        ;
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/pixman/pixman.git";
      rev-prefix = "pixman-";
    };
  };

  meta = with lib; {
    homepage = "http://pixman.org";
    description = "Low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
    pkgConfigModules = [ "pixman-1" ];
  };
})
