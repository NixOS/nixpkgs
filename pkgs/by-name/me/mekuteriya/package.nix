{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mekuteriya";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "mek-ut-er-ya";
    rev = version;
    hash = "sha256-bWp2UNrhCHY2DQWusGS9L9/jI2r23F34yLpuE6nuOD0=";
  };

  cargoHash = "sha256-YIsM2IVtV1jG/JzCR9gQPqnKhtxJYdCWdTw4FlK3Y9w=";

  meta = {
    description = "Ethiopian Calendar CLI";
    homepage = "https://github.com/frectonz/mek-ut-er-ya";
    mainProgram = "mekuteriya";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
  };
}
