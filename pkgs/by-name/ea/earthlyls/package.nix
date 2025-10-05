{
  lib,
  fetchFromGitHub,
  rustPlatform,

  earthlyls,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "earthlyls";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "glehmann";
    repo = "earthlyls";
    rev = version;
    hash = "sha256-GnFzfCjT4kjb9WViKIFDkIU7zVpiI6HDuUeddgHGQuc=";
  };

  cargoHash = "sha256-sWbYN92Jfr/Pr3qoHWkew/ASIdq8DQg0WHpdyklGBLo=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = earthlyls; };
  };

  meta = {
    description = "Earthly language server";
    homepage = "https://github.com/glehmann/earthlyls";
    changelog = "https://github.com/glehmann/earthlyls/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "earthlyls";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
