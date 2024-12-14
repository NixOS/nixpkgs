{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "javascript-typescript-langserver";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "javascript-typescript-langserver";
    rev = "v${version}";
    hash = "sha256-vd7Hj0jPFgK0u3CBlMfOFERmW+w9CnKIY9nvs48KqsI=";
  };

  npmDepsHash = "sha256-nHGTi1aH9YY01dzBeNyUEUEswrdjZPWaoycDVZZmIAA=";

  meta = {
    description = "JavaScript and TypeScript code intelligence through the Language Server Protocol";
    homepage = "https://github.com/sourcegraph/javascript-typescript-langserver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dywedir ];
  };
}
