{
  stdenv,
  lib,
  bundlerEnv,
  makeWrapper,
  bundlerUpdateScript,
}:
let
  rubyEnv = bundlerEnv {
    name = "jsduck";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation {
  pname = "jsduck";
  version = (import ./gemset.nix).jsduck.version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ rubyEnv ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/jsduck $out/bin/jsduck
  '';

  passthru.updateScript = bundlerUpdateScript "jsduck";

  meta = with lib; {
    description = "Simple JavaScript Duckumentation generator";
    mainProgram = "jsduck";
    homepage = "https://github.com/senchalabs/jsduck";
    license = with licenses; gpl3;
    maintainers = with maintainers; [
      periklis
      nicknovitski
    ];
    platforms = platforms.unix;
    # rdiscount fails to compile with:
    # mktags.c:44:1: error: return type defaults to ‘int’ [-Wimplicit-int]
    broken = true;
  };
}
