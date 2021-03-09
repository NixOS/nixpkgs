{ lib, bundlerEnv, bundlerUpdateScript }:

bundlerEnv {
  pname = "watir";
  gemdir = ./.;

  meta = with lib; {
    description = "Watir is an open source Ruby library for automating tests.";
    homepage    = "http://watir.github.io/";
    license     = licenses.mit;
    maintainers = with maintainers; [ ngiger ];
    platforms   = platforms.unix;
  };
}
