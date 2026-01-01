{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
<<<<<<< HEAD
  version = "0.20.1";
=======
  version = "0.19.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-67kMAUwgrQcGipsbKo0kubkVJA4/T4nfqghEZlhnvHU=";
  };

  cargoHash = "sha256-t0R2QMmNpLgqmqLVL4hgEcqN0xIUIK3gIwxZxzkupbQ=";
=======
    hash = "sha256-a7GUv14iJLrgXu6y5uJalD1cx723aIlPLDPOOoemtIY=";
  };

  cargoHash = "sha256-ZWVNLI900SZhXLMV2/v3WT2eqv+4XofpIgm/f/0eE+U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obs-cmd";
  };
})
