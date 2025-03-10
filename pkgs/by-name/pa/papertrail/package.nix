{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  testers,
  papertrail,
}:

let
  papertrail-env = bundlerEnv {
    name = "papertrail-env";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation {
  pname = "papertrail";
  version = (import ./gemset.nix).papertrail.version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${papertrail-env}/bin/papertrail $out/bin/papertrail
  '';

  passthru.updateScript = bundlerUpdateScript "papertrail";

  passthru.tests.version = testers.testVersion { package = papertrail; };

  meta = with lib; {
    description = "Command-line client for Papertrail log management service";
    mainProgram = "papertrail";
    homepage = "https://github.com/papertrail/papertrail-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = ruby.meta.platforms;
  };
}
