{
  lib,
  php82,
  fetchFromGitHub,
  fetchpatch,
}:

php82.buildComposerProject (finalAttrs: {
  pname = "robo";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-tibG2sR5CsRnUjZEvOewX/fyMuAS1kgKjYbrkk+f0BI=";
  };

  patches = [
    # Fix the version number
    # Most likely to remove at the next bump update
    # See https://github.com/drupol/robo/pull/1
    (fetchpatch {
      url = "https://github.com/drupol/robo/commit/c3cd001525c1adb5980a3a18a5561a0a5bbe1f50.patch";
      hash = "sha256-iMdZx+Bldmf1IS6Ypoet7GSsE6J9ZnE0HTskznkyEKM=";
    })
  ];

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
