{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reddsaver";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7jc8a2H/90BNyn3sAHzGO7nlg7VYEYIBF/x8wAHLuh8=";
  };

  cargoHash = "sha256-xYtdGhuieFudfJz+LxUjP7mV8uItaIvLahCH7vBWTtg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "CLI tool to download saved media from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.manojkarthick ];
    mainProgram = "reddsaver";
  };

})
