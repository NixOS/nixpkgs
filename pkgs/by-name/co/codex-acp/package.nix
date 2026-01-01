{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "codex-acp";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QGK4CkcH3eaOsjBwCoUSIYglFQ7pw0KtIfJAR9tTpbI=";
  };

  cargoHash = "sha256-Cojr5+ZZTpnOYA0QJ622UFlMhiEbdkkxvnVQqkFxBEI=";
=======
    hash = "sha256-PY8nEHH/Wu5K0V1A3DbgEYXjgh1noO2uGeb6eRsTzRw=";
  };

  cargoHash = "sha256-mswFSCdo/QEPVoMTJRtdAzgI9mQmFqmRIUxhb5qV+OY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    changelog = "https://github.com/zed-industries/codex-acp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
=======
  meta = with lib; {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    changelog = "https://github.com/zed-industries/codex-acp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tlvince ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "codex-acp";
  };
}
