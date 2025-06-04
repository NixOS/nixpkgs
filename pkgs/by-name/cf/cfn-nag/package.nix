{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv rec {
  pname = "cfn-nag";
  version = "0.8.10";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript pname;

  meta = {
    description = "Linting tool for CloudFormation templates";
    homepage = "https://github.com/stelligent/cfn_nag";
    mainProgram = "cfn_nag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      momeemt
      mathstlouis
    ];
    platforms = lib.platforms.unix;
  };
}
