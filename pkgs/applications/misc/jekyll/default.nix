{ stdenv, lib, bundlerEnv, ruby_2_1, curl }:

bundlerEnv {
  name = "jekyll-2.5.3";

  ruby = ruby_2_1;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  buildInputs = [ curl ];

  meta = with lib; {
    description = "Simple, blog aware, static site generator";
    homepage    =  http://jekyllrb.com/;
    license     = licenses.mit;
    maintainers = with maintainers; [ pesterhazy ];
    platforms   = platforms.unix;
  };
}
