{
  lib,
  fetchFromGitHub,
  php83,
  versionCheckHook,
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-Lq9TEwhcsoO4Cau2S7i/idEZYIzBeI0iXX1Ol7LnbAo=";
  };

  vendorHash = "sha256-JxUVqQjSBh8FYW1JbwooHHkzDRtMRaCuVO6o45UMzOk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    teams = [ lib.teams.php ];
  };
})
