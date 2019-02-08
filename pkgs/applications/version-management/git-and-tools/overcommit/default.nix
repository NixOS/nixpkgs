{ lib, bundlerApp }:

bundlerApp {
  pname = "overcommit";
  gemdir = ./.;

  exes = [ "overcommit" ];

  meta = with lib; {
    description = "A fully configurable and extendable Git hook manager";
    homepage = https://github.com/brigade/overcommit;
    license = with licenses; mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
