{ stdenv, lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "pt-0.7.3";

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage    = http://www.github.com/raul/pt;
    license     = licenses.mit;
    maintainers = with maintainers; [ ebzzry ];
    platforms   = platforms.unix;
  };
}
