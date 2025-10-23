{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgif";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i8xngmVhRCGkczY3NzomLkXj+iqPb81lvLn6dXsByYs=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    homepage = "https://github.com/dloebl/cgif";
    description = "GIF encoder written in C";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
