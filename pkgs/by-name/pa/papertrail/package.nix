{
  lib,
  stdenv,
  bundlerEnv,
  makeWrapper,
  ruby,
  bundlerUpdateScript,
  testers,
  papertrail,
}:

stdenv.mkDerivation rec {
  pname = "papertrail";
  version = (import ./gemset.nix).papertrail.version;

  env = bundlerEnv {
    name = "papertrail";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ env ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/papertrail $out/bin/papertrail
  '';

  passthru.updateScript = bundlerUpdateScript "papertrail";

  meta = with lib; {
    description = "Command-line client for Papertrail log management service";
    mainProgram = "papertrail";
    homepage = "https://github.com/papertrail/papertrail-cli/";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = ruby.meta.platforms;
  };
}
