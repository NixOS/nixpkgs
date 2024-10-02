# To run it call: nix-build -A postrunner.tests
{ lib, bundlerApp, bundlerUpdateScript, callPackage }:

bundlerApp {
  pname = "postrunner";
  gemdir = ./.;
  exes = [ "postrunner" ];
  passthru.updateScript = bundlerUpdateScript "postrunner";
  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };


  meta = with lib; {
    description = "PostRunner is an application to manage FIT files produced by Garmin products";
    homepage    = "https://github.com/scrapper/postrunner";
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ ngiger ];
    platforms   = platforms.unix;
  };
}
