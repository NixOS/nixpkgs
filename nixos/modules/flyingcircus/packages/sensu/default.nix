{ lib, bundlerEnv, ruby_2_0, pkgs }:

  bundlerEnv {
  name = "sensu-0.22.1";

  ruby = ruby_2_0;

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A monitoring framework that aims to be simple, malleable, and scalable";
    homepage    = http://sensuapp.org/;
    license     = licenses.mit;
    maintainers = with maintainers; [ theuni ];
    platforms   = platforms.unix;
  };

}
