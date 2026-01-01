{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    hash = "sha256-WrzIqt28RhoFYhCMu5oY5jAdGh0Gv5uryW/1jTX99aY=";
  };

  cargoHash = "sha256-IgGuWIsDsiMqscO4B876iTCdrR+nI9bpTQOyxjCtjMk=";

<<<<<<< HEAD
  meta = {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = lib.licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with lib.maintainers; [ astro ];
=======
  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with maintainers; [ astro ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
