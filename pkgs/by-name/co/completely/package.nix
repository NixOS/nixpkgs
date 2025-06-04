{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "completely";

  gemdir = ./.;
  exes = [ "completely" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = {
    description = "Generate bash completion scripts using a simple configuration file";
    homepage = "https://github.com/DannyBen/completely";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = pname;
  };
}
