{
  stdenv,
  lib,
  rustPlatform,
  version,
  src,
  cargoHash,
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  env ? { },
  passthru ? { },
  ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iocaine";

  inherit
    version
    src
    cargoHash
    buildInputs
    nativeBuildInputs
    env
    passthru
    ;

  __structuredAttrs = true;

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
