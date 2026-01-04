{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playball";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "paaatrick";
    repo = "playball";
    tag = "v${version}";
    hash = "sha256-xgAhzNWCLNmbrwaYAGmXMercoRgXWPjjV5dcnXunmeA=";
  };

  npmDepsHash = "sha256-s0JKBJnVYkeXOE62F6BZRKwd0Hg3IOuMai6rmKUi6TI=";

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
