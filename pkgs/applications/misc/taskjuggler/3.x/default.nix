{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "taskjuggler-3.5.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = {
    description = "A modern and powerful project management tool";
    homepage    = http://taskjuggler.org/;
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
  };
}
