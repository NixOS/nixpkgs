{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "playball";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "paaatrick";
    repo = "playball";
    tag = "v${version}";
    hash = "sha256-kahotL2cF2j8DHB1HkSyKwcmOUMcoDO/yS9DXwGcZc0=";
  };

  npmDepsHash = "sha256-joHk2xYSoipxd4IVgiwinYMacw8jlvtn4K03J8AdzY0=";

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
