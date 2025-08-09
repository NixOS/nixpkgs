{
  lib,
  fetchFromGitHub,
  php83,
  versionCheckHook,
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-v6Be9yODeac4ZLYfHXZTLMcfzjKGDXD7jz7kmI/z8wo=";
  };

  vendorHash = "sha256-vaRRxtHu/ZFc+Z38KJjm0iUncFYUfRLkk7A3+T1p4+I=";

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
