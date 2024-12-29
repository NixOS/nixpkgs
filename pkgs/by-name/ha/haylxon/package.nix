{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "haylxon";
  version = "1.0.0";

  src = fetchCrate {
    inherit version;
    pname = "hxn";
    hash = "sha256-zAqYaPtbXqC1YFzCL8EwE1HhuSqVl5lAfnAftwBvnoE=";
  };

  cargoHash = "sha256-6vVsm4gdcFCxKvvmOi3wlHkFoZp8CG+u50NfxIZqCl8=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = {
    description = "Save screenshots of urls and webpages from terminal";
    homepage = "https://github.com/pwnwriter/haylxon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scientiac ];
    mainProgram = "hxn";
  };
}
