{
  lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "robo";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-rpCs24Q15XM4BdW1+IfysFR/8/ZU4o5b4MyJL48uDaU=";
  };

  vendorHash = "sha256-Ul8XjH0Nav37UVpNQslOkF2bkiyqUAEZiIbcSW2tGkQ=";

  meta = {
    changelog = "https://github.com/consolidation/robo/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Modern task runner for PHP";
    homepage = "https://github.com/consolidation/robo";
    license = lib.licenses.mit;
    mainProgram = "robo";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
