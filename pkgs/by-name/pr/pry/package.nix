{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "pry";
  gemdir = ./.;
  exes = [ "pry" ];

  passthru.updateScript = bundlerUpdateScript "pry";

  meta = {
    description = "Ruby runtime developer console and IRB alternative";
    homepage = "https://pryrepl.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tckmn ];
    platforms = lib.platforms.unix;
  };
}
