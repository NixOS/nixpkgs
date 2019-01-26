{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "timetrap-${version}";

  version = (import gemset).timetrap.version;
  inherit ruby;
  gemdir = ./.;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A simple command line time tracker written in ruby";
    homepage = https://github.com/samg/timetrap;
    license = licenses.mit;
    maintainers = [ maintainers.jerith666 ];
  };
}
