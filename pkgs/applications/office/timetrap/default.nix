{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "timetrap";
  gemdir = ./.;
  exes = [ "t" "timetrap" ];

  passthru.updateScript = bundlerUpdateScript "timetrap";

  meta = with lib; {
    description = "A simple command line time tracker written in ruby";
    homepage    = "https://github.com/samg/timetrap";
    license     = licenses.mit;
    maintainers = with maintainers; [ jerith666 manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
