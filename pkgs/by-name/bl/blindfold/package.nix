{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blindfold";
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Eoin-McMahon";
    repo = "blindfold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-faSuaeOlFu7cw6WJxsHn/dQOfIzvxJNIadacgTfan7w=";
  };

  cargoHash = "sha256-Wwpl1U96CYt5WDEaiibP/ZiJyDDaPfrd1g8/qFOENDg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = {
    description = "A simple and lightwheight .gitignore generator";
    mainProgram = "blindfold";
    maintainers = with lib.maintainers; [ idkdontaskm3 ];
    license = with lib.licenses; [ mit ];
  };
})
