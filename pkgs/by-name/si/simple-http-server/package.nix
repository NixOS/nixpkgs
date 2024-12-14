{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r8Ush6cdGNxcRB3RSRJLtjseII5SQt9+oMqOTBmVfaY=";
  };

  cargoHash = "sha256-RdHcMnUctHYdQRsF6T9w8FoD56Bv4Xm0Jlu4Rls0C+M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      mephistophiles
    ];
    mainProgram = "simple-http-server";
  };
}
