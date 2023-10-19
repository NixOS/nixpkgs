{
  lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "robo";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-4sQc3ec34F5eBy9hquTqmzUgvFCTlml3LJdP39gPim4=";
  };

  vendorHash = "sha256-QX7AFtW6Vm9P0ABOuTs1U++nvWBzpvtxhTbK40zDYqc=";

  meta = {
    changelog = "https://github.com/consolidation/robo/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Modern task runner for PHP";
    homepage = "https://github.com/consolidation/robo";
    license = lib.licenses.mit;
    mainProgram = "robo";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
