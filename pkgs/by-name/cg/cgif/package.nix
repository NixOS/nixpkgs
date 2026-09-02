{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgif";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rWw7dlqS/NsrrtRfYfmnC6ubHJLie5301S9C0uognnw=";
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
