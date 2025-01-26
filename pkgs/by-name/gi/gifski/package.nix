{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ffmpeg_6,
}:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    hash = "sha256-Sl8HRc5tfRcYxXsXmvZ3M+f7PU7+1jz+IKWPhWWQ/us=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iWH0lXHolLpNVE/pgy1cOwiTMNRVy2JrruhQ/S4tp8M=";

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
