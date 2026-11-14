{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  ffmpeg_6,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gifski";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = finalAttrs.version;
    hash = "sha256-8EAC8YH3AIbvYdTL7HtqTL7WqztzCwvDwIVkhiqvtrQ=";
  };

  cargoHash = "sha256-ZppSO3TyZBbNhG+YW71+C9kMu7ok2+kbnnCRbAKsbfs=";

  patches = [
    # The `errors` test depends on thread scheduling and fails on aarch64-darwin
    # https://github.com/ImageOptim/gifski/issues/364
    (fetchpatch {
      name = "verbose-assert.patch";
      url = "https://github.com/ImageOptim/gifski/commit/cab11b8b5bc5d8cb13e036da6918ff8de74a37f5.patch";
      hash = "sha256-1KT6awc3jjtUQVmkOEhdbVGl5nz6OLSTIUbGbeLcDNo=";
    })
    (fetchpatch {
      name = "fix-errors-test.patch";
      url = "https://github.com/ImageOptim/gifski/commit/5d78be28ad2e188da2f1509c389d2733da174366.patch";
      hash = "sha256-i3j3otZ+2HKSggGAor0k+6F4YzjR9asUN/9ivOdI2vg=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg_6
  ];

  buildFeatures = [ "video" ];

  # When the default checkType of release is used, we get the following error:
  #
  #   error: the crate `gifski` is compiled with the panic strategy `abort` which
  #   is incompatible with this crate's strategy of `unwind`
  #
  # It looks like https://github.com/rust-lang/cargo/issues/6313, which does not
  # outline a solution.
  #
  checkType = "debug";

  meta = {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    changelog = "https://github.com/ImageOptim/gifski/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    mainProgram = "gifski";
  };
})
