{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "38ae6d591a9b85dc43ab62b7e065e76fd4bb4d20";
    hash = "sha256-CVZ6txAPQJWuOP7NHcYHs5AId1nIfTocg8AHt/4r6Vk=";
  };

  cargoHash = "sha256-cH+cgYIUPQTHgGCZmP562VzCxz+i6LkymHtnHJXnd+A=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
