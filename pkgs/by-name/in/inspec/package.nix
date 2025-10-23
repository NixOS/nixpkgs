{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "inspec";
  gemdir = ./.;

  inherit ruby;

  exes = [ "inspec" ];

  passthru.updateScript = bundlerUpdateScript "inspec";

  meta = {
    description = "Open-source testing framework for infrastructure with a human- and machine-readable language for specifying compliance, security and policy requirements";
    homepage = "https://inspec.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    mainProgram = "inspec";
  };
}
