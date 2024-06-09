{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, nodejs
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bqn";
  version = "0-unstable-2024-05-13";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "c971a177421d532a13c4b7515535552df19681e1";
    hash = "sha256-Fru1IIb4IxBQxrEEBoRYStxBqYJJqd+Q+Hwyk++QA68=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ nodejs ];

  patches = [
    # Creates a @libbqn@ substitution variable, to be filled in postFixup
    ./001-libbqn-path.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/bqn
    cp bqn.js $out/share/bqn/bqn.js
    cp docs/bqn.js $out/share/bqn/libbqn.js

    makeWrapper "${lib.getBin nodejs}/bin/node" "$out/bin/mbqn" \
      --add-flags "$out/share/bqn/bqn.js"

    ln -s $out/bin/mbqn $out/bin/bqn

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/bqn/bqn.js \
      --subst-var-by "libbqn" "$out/share/bqn/libbqn.js"
  '';

  dontConfigure = true;

  dontBuild = true;

  strictDeps = true;

  meta = {
    homepage = "https://github.com/mlochbaum/BQN/";
    description = "The original BQN implementation in Javascript";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (nodejs.meta) platforms;
  };
})
# TODO: install docs and other stuff
