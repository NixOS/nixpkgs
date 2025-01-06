{
  stdenv,
  lib,
  bundlerEnv,
  makeWrapper,
  bundlerUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "jsduck";
  version = (import ./gemset.nix).jsduck.version;

  env = bundlerEnv {
    name = pname;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ env ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/jsduck $out/bin/jsduck
  '';

  passthru.updateScript = bundlerUpdateScript "jsduck";

  meta = {
    description = "Simple JavaScript Duckumentation generator";
    mainProgram = "jsduck";
    homepage = "https://github.com/senchalabs/jsduck";
    license = with lib.licenses; gpl3;
    maintainers = with lib.maintainers; [
      periklis
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
