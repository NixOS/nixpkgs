{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playball";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "paaatrick";
    repo = "playball";
    tag = "v${version}";
    hash = "sha256-okcER6Z0q7wBvdspB+VCVK9adIgEoCpLcKRQTXOAVGA=";
  };

  npmDepsHash = "sha256-O2gK40vRb/5S7QlYs+niTJVIj9w9zuiMjBZxC8ZM67I=";

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
