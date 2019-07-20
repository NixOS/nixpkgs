{ lib, bundlerApp }:

bundlerApp {
  pname = "timetrap";
  gemdir = ./.;
  exes = [ "t" "timetrap" ];

  meta = with lib; {
    description = "A simple command line time tracker written in ruby";
    homepage    = https://github.com/samg/timetrap;
    license     = licenses.mit;
    maintainers = with maintainers; [ jerith666 manveru ];
    platforms   = platforms.unix;
  };
}
