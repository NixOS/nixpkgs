{
  lib,
  bundlerApp,
  ruby_3_4,
  bundlerUpdateScript,
}:

(bundlerApp.override { ruby = ruby_3_4; }) {
  pname = "lolcat";
  gemdir = ./.;
  exes = [ "lolcat" ];

  passthru.updateScript = bundlerUpdateScript "lolcat";

  meta = {
    description = "Rainbow version of cat";
    homepage = "https://github.com/busyloop/lolcat";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.StillerHarpo
      lib.maintainers.manveru
      lib.maintainers.nicknovitski
    ];
    mainProgram = "lolcat";
  };
}
