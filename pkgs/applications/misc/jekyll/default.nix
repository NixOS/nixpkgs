{ stdenv, lib, bundlerEnv, ruby
, withOptionalDependencies ? false
}:

bundlerEnv rec {
  name = pname + "-" + version;
  pname = "jekyll";
  version = (import "${gemdir}/gemset.nix").jekyll.version;

  inherit ruby;
  gemdir = if withOptionalDependencies
    then ./full
    else ./basic;

  meta = with lib; {
    description = "Simple, blog aware, static site generator";
    homepage    = https://jekyllrb.com/;
    license     = licenses.mit;
    maintainers = with maintainers; [ primeos pesterhazy ];
    platforms   = platforms.unix;
  };
}
