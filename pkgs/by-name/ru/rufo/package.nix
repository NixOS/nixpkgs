{
  bundlerApp,
  bundlerUpdateScript,
  lib,
}:

bundlerApp {
  pname = "rufo";
  gemdir = ./.;
  exes = [ "rufo" ];

  passthru.updateScript = bundlerUpdateScript "rufo";

  meta = {
    description = "Ruby formatter";
    homepage = "https://github.com/ruby-formatter/rufo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andersk ];
    mainProgram = "rufo";
  };
}
