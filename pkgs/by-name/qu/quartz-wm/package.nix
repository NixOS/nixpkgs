{
  lib,
  clangStdenv,
  fetchgit,
  fetchpatch,
  autoreconfHook,
  pixman,
  pkg-config,
  util-macros,
  libxinerama,
  libapplewm,
  xorgproto,
  libxrandr,
  libxext,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "quartz-wm";
  version = "1.3.2";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xorg/app/quartz-wm.git";
    tag = "quartz-wm-${finalAttrs.version}";
    hash = "sha256-1+KZNeR4Gq2uWBHTN53PTITHuly1Z4buR+grzdVNwhs=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/app/quartz-wm/-/commit/2f7b5957ffb05dfbf9182f1f2a1ad13069802946.patch";
      hash = "sha256-z6jd4Q6deMnawIF6wsztJmHWfK5ZGCyyW09cZzLOx00=";
    })
  ];

  configureFlags = [ "--enable-xplugin-dock-support" ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];
  buildInputs = [
    libxinerama
    libapplewm
    xorgproto
    libxrandr
    libxext
    pixman
  ];

  meta = {
    homepage = "https://gitlab.freedesktop.org/xorg/app/quartz-wm";
    license = lib.licenses.apple-psl20;
    platforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.booxter ];
    mainProgram = "quartz-wm";
  };
})
