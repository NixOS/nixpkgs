{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  bison,
  flex,
  libxext,
  libxmu,
  libxpm,
  libxp,
  libxt,
  xorgproto,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxaw3d";
  version = "1.6.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxaw3d";
    tag = "libXaw3d-${finalAttrs.version}";
    hash = "sha256-7w5FnvxbztfdH7QPPqvHyJdAhTyNfe0Je4x+J80dJIY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    bison
    flex
  ];

  buildInputs = [
    libxext
    libxpm
  ];

  propagatedBuildInputs = [
    libxmu
    libxt
    xorgproto
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=libXaw3d-(.*)" ]; };
  };

  meta = {
    description = "3D appearance variant of the X Athena Widget Set";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxaw3d";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
