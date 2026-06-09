{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gimoji";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = finalAttrs.version;
    hash = "sha256-2YalpSPG5qzIW/CHlTVnKcvBi0eqD3B5K/KXE7mJwM0=";
  };

  cargoHash = "sha256-t2SE3xvLNVra2hU+Fa81dHbopIbl7GgOcef6tUGdbTE=";

  meta = {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = lib.licenses.mit;
    mainProgram = "gimoji";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
})
