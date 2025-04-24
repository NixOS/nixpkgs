{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "concord";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Cogmasters";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ak1eOLwmz3XkWpRrzgf0ayzb8Q9B6uWXfkhrdBLA2Uw=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildInputs = [ curl ];

  meta = {
    description = "Discord API wrapper library made in C";
    homepage = "https://cogmasters.github.io/concord/";
    changelog = "https://github.com/Cogmasters/concord/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
  };
})
