{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playball";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "paaatrick";
    repo = "playball";
    tag = "v${version}";
    hash = "sha256-Kg1ooxtXwP2q9qa7uuzUtl2R8/jqG9wryaKWYnWXIjw=";
  };

  npmDepsHash = "sha256-waaC5AcsEWMOLyXSmMbRuRS5Ozq5ERrmONQZhP05Kes=";

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
