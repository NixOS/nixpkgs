{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgif";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sZan1SLY4HGoifgGOb+uo4/q4dtxZuWAYhMbvdl/Ap8=";
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
