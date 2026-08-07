{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nasm,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "primage";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "imfing";
    repo = "primage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qfGQ9tJANu+2Hx83hDWzEMXvfGtzDntEVui6AYso4Xo=";
  };

  cargoHash = "sha256-wSvs5rp2QVJwBSgTAUrhsI7zp14QMTK8bt3DvEOUm44=";

  # for rav1e
  nativeBuildInputs = [ nasm ];

  meta = {
    description = "A fast CLI for compressing and converting images";
    homepage = "https://github.com/imfing/primage";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yarn ];
    mainProgram = "primage";
  };
})
