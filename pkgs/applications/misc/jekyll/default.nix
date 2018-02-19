{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = pname + "-" + version;
  pname = "jekyll";
  version = (import ./gemset.nix).jekyll.version;

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "Simple, blog aware, static site generator";
    homepage    = https://jekyllrb.com/;
    license     = licenses.mit;
    maintainers = with maintainers; [ primeos pesterhazy ];
    platforms   = platforms.unix;
  };
}
