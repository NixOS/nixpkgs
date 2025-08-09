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
  version = "24.2.5";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-WS3hd84vDSH/u7AxtkPL8E1UutUKHzARSzVYOHLlKPU=";
  };

  npmDepsHash = "sha256-uQWQ+0Ub1piW/BATHrrWfzjv10/f2fyVL5JwDF1NdqM=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools;

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
