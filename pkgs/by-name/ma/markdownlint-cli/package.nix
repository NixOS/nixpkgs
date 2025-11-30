{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-8yzTdgwKM2xSNJvqpQM/WSFVDVUDdFgpcIxr13thIYQ=";
  };

  npmDepsHash = "sha256-FQKjIAVvaAz4OsCZ1gKNLdHWhANdUKbFsD9HMksVu+U=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
