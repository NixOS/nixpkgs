{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/LgQqxZqxbE8hgip+yl8VVjiRYD+6AblKag2MQo1gDs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZKHm6N7y5FbDFiK2QfQ+9siexgzrdLpBs5Xikh1SRLo=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "obs-cmd";
  };
})
