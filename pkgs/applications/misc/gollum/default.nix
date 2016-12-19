{ stdenv, lib, bundlerEnv, ruby_2_2, icu, zlib }:

bundlerEnv rec {
  name = "gollum-${version}";
  version = "4.0.1";

  ruby = ruby_2_2;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A simple, Git-powered wiki";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = platforms.unix;
  };
}
