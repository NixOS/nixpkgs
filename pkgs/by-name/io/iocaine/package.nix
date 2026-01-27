{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "iocaine";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${version}";
    hash = "sha256-FLjoOAiKwxQ6fs/p943lb4+vM8cXHlThBCeyBdo1GRo=";
  };

  cargoHash = "sha256-UDsF8OeylCz0YfmhZ+phfQfC9HpweI51G4OHnK1dDfk=";

  meta = {
    description = "Deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    changelog = "https://git.madhouse-project.org/iocaine/iocaine/src/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sugar700 ];
    mainProgram = "iocaine";
    # Lacking OS access to fix, and upstream doesn't support macOS.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
