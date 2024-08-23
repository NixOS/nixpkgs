{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  pkg-config,
  libiconv,
  enableLTO ? true,
  nrxAlias ? true,
}:
rustPlatform.buildRustPackage rec {
  pname = "nrr";
  version = "0.9.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${version}";
    hash = "sha256-X1zgQvgjWbTQAOHAZ+G2u0yO+qeiU0hamTLM39VOK20=";
  };

  cargoHash = "sha256-NpvYN68l5wibrFxST35sWDBbUG1mauNszA8NYIWGGa0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.IOKit
    libiconv
  ];

  nativeBuildInputs = [ pkg-config ];

  env = lib.optionalAttrs enableLTO {
    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  postInstall = lib.optionalString nrxAlias "ln -s $out/bin/nr{r,x}";

  meta = with lib; {
    description = "Minimal, blazing fast npm scripts runner";
    homepage = "https://github.com/ryanccn/nrr";
    maintainers = with maintainers; [ ryanccn ];
    license = licenses.gpl3Only;
    mainProgram = "nrr";
  };
}
