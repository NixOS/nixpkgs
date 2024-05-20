{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-janitor";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nobbz";
    repo = "nix-janitor";
    rev = "refs/tags/${version}";
    hash = "sha256-nGtbBNU6xFWXnmL1AaUbSpO0z5Kq2t/Mn8sqwzjNlkE=";
  };

  cargoHash = "sha256-j3i4c3KjI8ehg42FqbPp+8M15zT9Bu76P4zv8ApUoeA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/nobbz/nix-janitor";
    changelog = "https://github.com/NobbZ/nix-janitor/blob/${version}/CHANGELOG.md";
    description = "A tool to clean up old profile generations";
    mainProgram = "janitor";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nobbz ];
  };
}
