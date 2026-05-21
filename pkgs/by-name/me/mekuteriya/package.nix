{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mekuteriya";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "mek-ut-er-ya";
    rev = finalAttrs.version;
    hash = "sha256-u3NK5KL3GjGekcFd4cB/z0omsL2FgiX8dMpcVl5h9s0=";
  };

  cargoHash = "sha256-pmy0jXFA6qt8U69CQBmpVWYr+Ifn0Z+Dj0hRHxHPBoQ=";

  meta = {
    description = "Ethiopian Calendar CLI";
    homepage = "https://github.com/frectonz/mek-ut-er-ya";
    mainProgram = "mekuteriya";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
  };
})
