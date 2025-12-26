{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "cddlc";

  gemdir = ./.;

  exes = [ "cddlc" ];

  passthru.updateScript = bundlerUpdateScript "cddlc";

  meta = {
    description = "CDDL conversion utilities";
    homepage = "https://github.com/cabo/cddlc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.unix;
    mainProgram = "cddlc";
  };
}
