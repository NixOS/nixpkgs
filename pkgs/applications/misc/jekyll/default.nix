{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "jekyll-${version}";

  version = (import gemset).jekyll.version;
  inherit ruby;
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
