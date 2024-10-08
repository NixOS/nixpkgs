{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "cfn-nag";
  version = "0.8.10";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "cfn-nag";

  meta = {
    description = "Linting tool for CloudFormation templates";
    homepage = "https://github.com/stelligent/cfn_nag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    platforms = lib.platforms.unix;
  };
}
