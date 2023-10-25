{ lib
, bundlerApp
}:

bundlerApp {
  pname = "iruby";
  gemdir = ./.;
  exes = [ "iruby" ];

  meta = with lib; {
    description = "Ruby kernel for Jupyter";
    homepage    = "https://github.com/SciRuby/iruby";
    license     = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    platforms   = platforms.unix;
  };
}
