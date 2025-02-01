{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "microserver";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "robertohuertasm";
    repo = "microserver";
    rev = "v${version}";
    sha256 = "sha256-VgzOdJ1JLe0acjRYvaysCPox5acFmc4VD2f6HZWxT8M=";
  };

  cargoHash = "sha256-JGsMtlWuww1rYE4w6i2VlyD6gGHqnLehLDZmW57R+Fo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks; [ Security ]
  );

  meta = with lib; {
    homepage = "https://github.com/robertohuertasm/microserver";
    description = "Simple ad-hoc server with SPA support";
    maintainers = with maintainers; [ flosse ];
    license = licenses.mit;
    mainProgram = "microserver";
  };
}
