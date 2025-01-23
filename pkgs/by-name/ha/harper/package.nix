{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-cUN7e82CncDzA9m+pcvtrAn10E6AYaMcAuu6hpt85tA=";
  };

  cargoHash = "sha256-lo3Ye7u26xLqlu/R4klYd2X9G73119XtWaJzVkl85+g=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
