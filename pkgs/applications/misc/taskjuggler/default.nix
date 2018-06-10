{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "taskjuggler-3.5.0";

  inherit ruby;
  gemdir = ./.;

  meta = {
    broken = true; # needs ruby 2.0
    description = "A modern and powerful project management tool";
    homepage    = http://taskjuggler.org/;
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
  };
}
