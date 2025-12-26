{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  wrapWithXFileSearchPathHook,
  libx11,
  libxaw,
  xbitmaps,
  libxmu,
  xorgproto,
  libxt,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bitmap";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "bitmap";
    tag = "bitmap-${finalAttrs.version}";
    hash = "sha256-UZxPc19jAqvJPwZSMf4seqxJNHeLOXA8bXh4y6D4gRE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxaw
    xbitmaps
    libxmu
    xorgproto
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=bitmap-(.*)" ]; };
  meta = {
    description = "X bitmap (XBM) editor and converter utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/app/bitmap";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "bitmap";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
