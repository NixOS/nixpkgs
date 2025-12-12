{
  php,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pdepend";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "pdepend";
    repo = "pdepend";
    tag = finalAttrs.version;
    hash = "sha256-2Ruubcm9IWZYu2LGeGeKm1tmHca0P5xlKYkuBCCV9ag=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-uK+nJFXDVPYFbosAUxqu+mmNsD7AnZ18NnIN9FYAaPQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/pdepend/pdepend/releases/tag/${finalAttrs.version}";
    description = "Adaptation of JDepend for PHP";
    homepage = "https://github.com/pdepend/pdepend";
    license = lib.licenses.bsd3;
    longDescription = "
      PHP Depend is an adaptation of the established Java
      development tool JDepend. This tool shows you the quality
      of your design in terms of extensibility, reusability and
      maintainability.
    ";
    mainProgram = "pdepend";
    teams = [ lib.teams.php ];
  };
})
