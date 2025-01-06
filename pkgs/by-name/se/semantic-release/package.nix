{
  cctools,
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  python3,
  stdenv,
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "24.2.1";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-E2OgtGVkACa7YWbS+lhWR/nBP9ED7FjFJsK37ntPPo4=";
  };

  npmDepsHash = "sha256-P6rxNaI125EqgXvZtMrcx38x6l0wOHQno7ojV+VFOkQ=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin cctools;

  # Fixes `semantic-release --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  meta = {
    description = "Fully automated version management and package publishing";
    mainProgram = "semantic-release";
    homepage = "https://semantic-release.gitbook.io/semantic-release/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sestrella ];
  };
}
