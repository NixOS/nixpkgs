{ lib, bundlerEnv, ruby_2_0, pkgs }:

bundlerEnv {
  name = "sensu-plugins";

  ruby = ruby_2_0;

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Selected plugins from http://sensu-plugins.io/";
    homepage    = http://sensu-plugins.io/;
    maintainers = with maintainers; [ theuni ];
    platforms   = platforms.unix;
  };

}
