{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-4akYngeDf7EqLxCzObjb5MUA8Cb3X3jlrvLEM71OcCA=";
  };

  npmDepsHash = "sha256-vtUtdgOJEQk9PzxOz7AlwOxWS6PTjAtrjAugXRXo89c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for creating better commits following the conventional commits specification";
    homepage = "https://github.com/Everduin94/better-commits";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "better-commits";
  };
}
