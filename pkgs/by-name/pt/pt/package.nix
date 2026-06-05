{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "pt";
  gemdir = ./.;
  exes = [ "pt" ];

  passthru.updateScript = bundlerUpdateScript "pt";

  meta = {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage = "http://www.github.com/raul/pt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "pt";
  };
}
