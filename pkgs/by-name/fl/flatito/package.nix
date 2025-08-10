{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "flatito";
  version = "1.4.5";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "flatito";

  meta = {
    description = "It allows you to search for a key and get the value and the line number where it is located in YAML and JSON files";
    homepage = "https://github.com/ceritium/flatito";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rucadi ];
    mainProgram = "flatito";
    platforms = lib.platforms.unix;
  };
}
