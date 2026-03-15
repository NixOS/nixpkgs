{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nestix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Noah765";
    repo = "nestix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5eYqyTgsrtEVf+Ypszt5x0qo1NHSv5YIhGuIIie7ec=";
  };

  cargoHash = "sha256-k4Ew8ezkmC2ThWcRCH2shkWrj1chdxNbHOrzguO6lTw=";

  meta = {
    description = "Structural Nix code formatter";
    homepage = "https://github.com/Noah765/nestix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Noah765 ];
    mainProgram = "nestix";
  };
})
