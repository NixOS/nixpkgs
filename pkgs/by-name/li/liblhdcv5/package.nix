{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cargo,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblhdcv5";
  version = "0.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DBeidachazi";
    repo = "liblhdcv5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ba2/zfcfmP0SRE7lYUOeEOcq3d8kXJeXdzhmFTMnwNI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vnNZ6gTW5zWEPpegBEu/8Jt1edZKJ/PhPT0XI664Ub8=";
  };

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    homepage = "https://github.com/DBeidachazi/liblhdcv5";
    description = "Native Linux build wrapper for the AOSP LHDC v5 encoder";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.imurx ];
    platforms = lib.platforms.linux;
  };
})
