{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "codex";
  version = "0.1.04160940"; # from codex-cli/package.json

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "e8afebac157f2069fc7ae0e33fb44c85ebf48892";
    hash = "sha256-FW03PSmeyJPDPpWw4XEqKZQqEwjOV2VFVQWXmXBevYU=";
  };

  sourceRoot = "${src.name}/codex-cli";

  npmDepsHash = "sha256-QdfO/p8oQnwIANeNRD0vD55v5lc9dHeaScpnpLqWdxc=";

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "codex";
  };
}
