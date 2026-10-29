{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  bibtex-tidy,
}:

buildNpmPackage (finalAttrs: {
  pname = "bibtex-tidy";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "FlamingTempura";
    repo = "bibtex-tidy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sMgy29deEfc3DFSC0Z4JZCeNAFpBKNYj+mJnFI1pSY4=";
  };

  npmDepsHash = "sha256-FKde5/ZZcS5g0fUaDjhRlKGLiS8kk1PvkZw9PUmvAAE=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  passthru.tests = {
    version = testers.testVersion {
      package = bibtex-tidy;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    changelog = "https://github.com/FlamingTempura/bibtex-tidy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Cleaner and Formatter for BibTeX files";
    mainProgram = "bibtex-tidy";
    homepage = "https://github.com/FlamingTempura/bibtex-tidy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bertof ];
  };
})
