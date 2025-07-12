{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ffmpeg_6,
}:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    hash = "sha256-IjQ2PqjXhNvXknVxfphSSwQEWBuTkSxMFrbwd2trlVI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2A7SDu9f7Tf74SAD72gCQ00Ccp3r2MaPo0qjVe3nR5s=";

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
    changelog = "https://github.com/ImageOptim/gifski/releases/tag/${src.rev}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "gifski";
  };
}
