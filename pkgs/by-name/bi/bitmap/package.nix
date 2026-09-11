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
  version = "1.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "bitmap";
    tag = "bitmap-${finalAttrs.version}";
    hash = "sha256-sQDt1zCxJ5kZ4kLVi1Wxrf7JiT721n2Sl6gNv3xZ0ts=";
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
