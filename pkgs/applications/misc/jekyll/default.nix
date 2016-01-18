{ stdenv, lib, bundlerEnv, ruby_2_2, curl }:

bundlerEnv rec {
  name = "jekyll-${version}";
  version = "3.0.1";

  ruby = ruby_2_2;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Simple, blog aware, static site generator";
    homepage    =  http://jekyllrb.com/;
    license     = licenses.mit;
    maintainers = with maintainers; [ pesterhazy ];
    platforms   = platforms.unix;
  };
}
