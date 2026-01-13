{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "codex-acp";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    tag = "v${version}";
    hash = "sha256-f3hT7sriur7hO8HY98fMlkugMstZTyeKnKjU7BoWerw=";
  };

  cargoHash = "sha256-HpoFJgPZnEo9cI9Qake3Z1S00O1KJEtmIde1vXbj8hA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    changelog = "https://github.com/zed-industries/codex-acp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "codex-acp";
  };
}
