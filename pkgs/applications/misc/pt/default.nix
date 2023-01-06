{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "pt";
  gemdir = ./.;
  exes = [ "pt" ];

  passthru.updateScript = bundlerUpdateScript "pt";

  meta = with lib; {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage    = "http://www.github.com/raul/pt";
    license     = licenses.mit;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
