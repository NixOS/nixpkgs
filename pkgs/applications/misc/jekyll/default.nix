{ stdenv, lib, bundlerEnv, ruby_2_2, curl }:

bundlerEnv rec {
  name = "jekyll-${version}";
  version = "3.1.6";

  ruby = ruby_2_2;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Simple, blog aware, static site generator";
    homepage    =  http://jekyllrb.com/;
    license     = licenses.mit;
    maintainers = with maintainers; [ pesterhazy fpletz ];
    platforms   = platforms.unix;
  };
}
