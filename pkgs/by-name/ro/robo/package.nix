{
  lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "robo";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-tibG2sR5CsRnUjZEvOewX/fyMuAS1kgKjYbrkk+f0BI=";
  };

  vendorHash = "sha256-RRnHv6sOYm8fYhY3Q6m5sFDflFXd9b9LPcAqk/D1jdE=";

  meta = {
    changelog = "https://github.com/consolidation/robo/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Modern task runner for PHP";
    homepage = "https://github.com/consolidation/robo";
    license = lib.licenses.mit;
    mainProgram = "robo";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
