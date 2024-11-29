{ lib, bundlerEnv, bundlerUpdateScript, ruby }:

bundlerEnv {
  pname = "license_finder";
  version = "7.0.1";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "license_finder";

  meta = with lib; {
    description = "Find licenses for your project's dependencies";
    homepage = "https://github.com/pivotal/licensefinder";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
