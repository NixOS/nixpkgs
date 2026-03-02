{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ducker";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-HQh6yXDovEf+bG+VcT6I5Q/NN3laSgPRm/2NdLpoAGE=";
  };

  cargoHash = "sha256-QnEhySY34b/PRsFr77AXhWMoirShSpcoIRQxnIVVM94=";

  meta = {
    description = "Terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ anas ];
  };
})
