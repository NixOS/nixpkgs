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

  gems = bundlerEnv {
    name = "papertrail";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gems ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${gems}/bin/papertrail $out/bin/papertrail
  '';

  passthru.updateScript = bundlerUpdateScript "papertrail";

  meta = {
    description = "Command-line client for Papertrail log management service";
    mainProgram = "papertrail";
    homepage = "https://github.com/papertrail/papertrail-cli/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicknovitski ];
    platforms = ruby.meta.platforms;
  };
}
