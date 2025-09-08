{
  lib,
  rustPlatform,
  fetchFromGitea,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "iocaine";
  version = "2.5.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${version}";
    hash = "sha256-213QLpGBKSsT9r8O27PyMom5+OGPz0VtRBevxswISZA=";
  };

  cargoHash = "sha256-EgPGDlJX/m+v3f/tGIO+saGHoYrtiWLZuMlXEvsgnxE=";

  buildInputs = [ curl ];

  meta = {
    description = "Deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    changelog = "https://git.madhouse-project.org/iocaine/iocaine/src/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sugar700 ];
    mainProgram = "iocaine";
  };
}
