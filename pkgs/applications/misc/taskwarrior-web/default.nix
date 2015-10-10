{ stdenv, lib, bundlerEnv, ruby }:

let
  version = "1.1.11";
in
bundlerEnv {
  name = "taskwarrior-web-${version}";

  inherit ruby;

  gemfile   = ./Gemfile;
  lockfile  = ./Gemfile.lock;
  gemset    = ./gemset.nix;

  meta = with lib; {
    description = "A Web Interface for Taskwarrior";
    homepage    = http://http://theunraveler.com/taskwarrior-web/;
    license     = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms   = platforms.unix;
  };
}
