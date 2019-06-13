{ lib, bundlerApp }:

bundlerApp {
  pname = "pt";
  gemdir = ./.;
  exes = [ "pt" ];

  meta = with lib; {
    description = "Minimalist command-line Pivotal Tracker client";
    homepage    = http://www.github.com/raul/pt;
    license     = licenses.mit;
    maintainers = with maintainers; [ ebzzry manveru ];
    platforms   = platforms.unix;
  };
}
