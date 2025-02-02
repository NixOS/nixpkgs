{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
}:

bundlerApp {
  pname = "cf-uaac";
  exes = [ "uaac" ];

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "cf-uaac";

  meta = with lib; {
    description = "CloudFoundry UAA Command Line Client";
    homepage = "https://github.com/cloudfoundry/cf-uaac";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "uaac";
  };
}
