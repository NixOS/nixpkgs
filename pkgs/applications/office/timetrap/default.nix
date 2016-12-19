{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "timetrap-1.10.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = {
    description = "A simple command line time tracker written in ruby";
    homepage = https://github.com/samg/timetrap;
    license = lib.licenses.mit;
  };
}
