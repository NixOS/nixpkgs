{
  lib,
  php82,
  fetchFromGitHub,
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "robo";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-bAT4jHvqWeYcACeyGtBwVBA2Rz+AvkZcUGLDwSf+fLg=";
  };

  vendorHash = "sha256-PYtZy6c/Z1GTcYyfU77uJjXCzQSfBaNkon8kqGyVq+o=";

  meta = {
    changelog = "https://github.com/consolidation/robo/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Modern task runner for PHP";
    homepage = "https://github.com/consolidation/robo";
    license = lib.licenses.mit;
    mainProgram = "robo";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
