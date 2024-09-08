{
  lib,
  fetchFromGitHub,
  php,
  testers,
  roave-backward-compatibility-check,
}:

php.buildComposerProject (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.9.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    rev = finalAttrs.version;
    hash = "sha256-Bvqo2SmtRWvatXxtHbctBrY0xe0KA+knNmEg+KC8hgY=";
  };

  vendorHash = "sha256-cMVOcLRvfwFbxd2mXJhDx1iaUTHPEsI4vh9/JCoOj3M=";

  passthru = {
    tests.version = testers.testVersion {
      package = roave-backward-compatibility-check;
      version = finalAttrs.version;
    };
  };

  meta = {
    changelog = "https://github.com/Roave/BackwardCompatibilityCheck/releases/tag/${finalAttrs.version}";
    description = "Tool that can be used to verify BC breaks between two versions of a PHP library";
    homepage = "https://github.com/Roave/BackwardCompatibilityCheck";
    license = lib.licenses.mit;
    mainProgram = "roave-backward-compatibility-check";
    maintainers = lib.teams.php.members;
  };
})
