{
  fetchurl,
  lib,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbacl";
  version = "1.14.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/dbacl/dbacl/${finalAttrs.version}/dbacl-${finalAttrs.version}.tar.gz";
    hash = "sha256-/w37Z2guhjscMlCsxEHOd8AzubIdjoeT5VtiLkIAWr0=";
  };

  # The build uses -std=c99, which hides POSIX declarations such as strdup and locale_t
  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Digramic Bayesian classifier for text recognition";
    homepage = "https://dbacl.sourceforge.net/";
    longDescription = "a digramic Bayesian classifier for text recognition.";
    maintainers = with lib.maintainers; [ kamadorueda ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "dbacl";
  };
})
