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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "glehmann";
    repo = "earthlyls";
    rev = version;
    hash = "sha256-wn+6Aa4xTC5o4S+N7snB/vlyw0i23XkmaXUmrhfXuaA=";
  };

  cargoHash = "sha256-eKBNZiFvIBuNPqDzMOa6J0UR4CIgi9OUowRaFSgi7Fg=";

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
    maintainers = with lib.maintainers; [ paveloom ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
