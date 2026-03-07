{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "simple-http-server";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = "simple-http-server";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ka6PU2Mbu7wIyj5hbAhUa8ncK61wcM+huSKYh/kiH7M=";
  };

  cargoHash = "sha256-0dODUHXeIVltwMn4U9Y4/NCOTuxkfVxpRYzXIHSTfQQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mephistophiles
    ];
    mainProgram = "simple-http-server";
  };
})
