{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.37.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-fXaOGdwpBbukphNvu9sONTXPAW+zMLv3roJ6j0iLdHQ=";
  };

  cargoHash = "sha256-AZsNtdUbtly1AN4dbBHRdlJCHkfcYjjKw5EzVqHMeYs=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jraygauthier ];
    mainProgram = "geckodriver";
  };
})
