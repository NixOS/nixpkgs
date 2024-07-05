{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "phraze";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "sts10";
    repo = "phraze";
    rev = "v${version}";
    hash = "sha256-1tvFVwTvtjAXVfCObdL3tGq50q4zouchNAuMo7euZ3g=";
  };

  doCheck = true;

  cargoHash = "sha256-q3nkNBEiisGp+ElSXZnT4x6P0Sm5sM2R9cpzpaJ/UU4=";

  meta = {
    description = "Generate random passphrases";
    homepage = "https://github.com/sts10/phraze";
    changelog = "https://github.com/sts10/phraze/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "phraze";
  };
}
