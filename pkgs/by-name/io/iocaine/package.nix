{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iocaine";
  version = "2.5.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${finalAttrs.version}";
    hash = "sha256-213QLpGBKSsT9r8O27PyMom5+OGPz0VtRBevxswISZA=";
  };

  cargoHash = "sha256-EgPGDlJX/m+v3f/tGIO+saGHoYrtiWLZuMlXEvsgnxE=";

  meta = {
    description = "Deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    changelog = "https://git.madhouse-project.org/iocaine/iocaine/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sugar700 ];
    mainProgram = "iocaine";
    # Lacking OS access to fix, and upstream doesn't support macOS.
    broken = stdenv.hostPlatform.isDarwin;
  };
})
