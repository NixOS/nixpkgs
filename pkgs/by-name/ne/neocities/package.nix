{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "neocities";
  gemdir = ./.;
  exes = [ "neocities" ];

  passthru.updateScript = bundlerUpdateScript "neocities";

  meta = {
    description = "CLI and library for interacting with the Neocities API";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = lib.licenses.mit;
    mainProgram = "neocities";
    maintainers = with lib.maintainers; [ dawoox ];
    platforms = lib.platforms.unix;
  };
}
