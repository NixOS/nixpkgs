{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playball";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "paaatrick";
    repo = "playball";
    tag = "v${version}";
    hash = "sha256-ldxYKLRtdNKU1xORT5HxgEMiMajUY7OwnkQ+jlsOIxY=";
  };

  npmDepsHash = "sha256-9sbTK7nV8m4uaUZy6DL/0r+JUlBoTkIpgYy7sacf130=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  meta = {
    changelog = "https://github.com/paaatrick/playball/releases/tag/v${version}";
    description = "Watch MLB games from the comfort of your own terminal";
    mainProgram = "playball";
    homepage = "https://github.com/paaatrick/playball";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickthegroot ];
  };
}
