{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
<<<<<<< HEAD
  version = "0-unstable-2025-12-29";
=======
  version = "0-unstable-2025-11-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
<<<<<<< HEAD
    rev = "3ebf6ddb6aef21433cf2e323ad19bded912ee2f9";
    hash = "sha256-jCU0AtkKfuZOZLuRdJ6qBcRydQykYgSbbhskfmmSqOc=";
=======
    rev = "3609f054a65aea4b4cab5a87b2fdc876d911d244";
    hash = "sha256-S18J0S50/S/50rCmcGkwSLslnA1abvsX9HhtFVcQ7XM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
