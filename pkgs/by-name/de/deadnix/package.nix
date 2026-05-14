{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadnix";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WrzIqt28RhoFYhCMu5oY5jAdGh0Gv5uryW/1jTX99aY=";
  };

  cargoHash = "sha256-IgGuWIsDsiMqscO4B876iTCdrR+nI9bpTQOyxjCtjMk=";

  meta = {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = lib.licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with lib.maintainers; [ astro ];
  };
})
