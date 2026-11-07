{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  cargo,
  rustc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblhdcv5";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DBeidachazi";
    repo = "liblhdcv5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ba2/zfcfmP0SRE7lYUOeEOcq3d8kXJeXdzhmFTMnwNI=";
  };

  patches = [
    (fetchpatch2 {
      name = "honor-prefix-in-generated-pkg-config-file.patch";
      url = "https://github.com/DBeidachazi/liblhdcv5/commit/0df76b08196dc26e460404189279b17a7101af74.patch?full_index=1";
      hash = "sha256-sNbZUA0Wq+CM/IZIFMbka6CmgsHhhyDhrmN8OmN9x8I=";
    })
  ];

  cargoRoot = "aosp";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-vnNZ6gTW5zWEPpegBEu/8Jt1edZKJ/PhPT0XI664Ub8=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  strictDeps = true;
  __structuredAttrs = true;

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "AOSP LHDC v5 Bluetooth encoder library for Linux";
    homepage = "https://github.com/DBeidachazi/liblhdcv5";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})
