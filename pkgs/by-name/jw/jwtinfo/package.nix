{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jwtinfo";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lmammino";
    repo = "jwtinfo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vtlYQdvLpxdN4WyBY4oQUaIZmTyE1GFGIIiho9IvTi8=";
  };

  cargoHash = "sha256-ydocnud3f9Cxd7qsYjeyNS7hv0g2Qry84IOw/dqemHY=";

  meta = {
    description = "Command-line tool to get information about JWTs";
    homepage = "https://github.com/lmammino/jwtinfo";
    changelog = "https://github.com/lmammino/jwtinfo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "jwtinfo";
  };
})
