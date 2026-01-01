{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mekuteriya";
<<<<<<< HEAD
  version = "0.1.6";
=======
  version = "0.1.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "mek-ut-er-ya";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-u3NK5KL3GjGekcFd4cB/z0omsL2FgiX8dMpcVl5h9s0=";
  };

  cargoHash = "sha256-pmy0jXFA6qt8U69CQBmpVWYr+Ifn0Z+Dj0hRHxHPBoQ=";
=======
    hash = "sha256-bWp2UNrhCHY2DQWusGS9L9/jI2r23F34yLpuE6nuOD0=";
  };

  cargoHash = "sha256-YIsM2IVtV1jG/JzCR9gQPqnKhtxJYdCWdTw4FlK3Y9w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Ethiopian Calendar CLI";
    homepage = "https://github.com/frectonz/mek-ut-er-ya";
    mainProgram = "mekuteriya";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frectonz ];
    platforms = lib.platforms.all;
  };
}
