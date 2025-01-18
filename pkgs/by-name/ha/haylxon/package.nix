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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Save screenshots of urls and webpages from terminal";
    homepage = "https://github.com/pwnwriter/haylxon";
    license = licenses.mit;
    maintainers = with maintainers; [ scientiac ];
    mainProgram = "hxn";
  };
}
