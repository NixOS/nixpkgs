{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
<<<<<<< HEAD
  version = "0.10.9";
=======
  version = "0.10.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-cSgKMeOW2oYy26HRo5qzoPHuoidqZ3TiLfgQAVbUIXA=";
  };

  npmDepsHash = "sha256-IOTcAylJuDorC6qPiQ2gJFeQu0dR+EAAKcyPsPdR0d0=";
=======
    hash = "sha256-eQhUXdYynBCv/6P60JRo43MDpWEPdIdEEQnFeY9AnhA=";
  };

  npmDepsHash = "sha256-dzgqmJPU3hIcQag+PnS1n8U05Mx+WN27d1Hwyy7CdZo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
