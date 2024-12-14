{
  lib,
  fetchFromGitHub,
  php,
  testers,
  roave-backward-compatibility-check,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.10.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    rev = finalAttrs.version;
    hash = "sha256-wOqF7FkwOnTxYe7OnAl8R7NyGkdJ37H0OIr5e/1Q03I=";
  };

  vendorHash = "sha256-Xd+SxqLbm5QCROwq4jDm4cWLxF2nraqA+xdrZxW3ILY=";

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
