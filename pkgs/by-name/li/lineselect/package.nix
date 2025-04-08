{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
}:

buildNpmPackage rec {
  pname = "lineselect";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "chfritz";
    repo = "lineselect";
    rev = "v${version}";
    hash = "sha256-dCmLD4Wjsdlta2xsFCMj1zWQr4HWCfcWsKVmrTND4Yw=";
  };

  npmDepsHash = "sha256-wBtswfXtJTI7um0HZQk1YygpSggZ4j0/7IBcJiQpOUY=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/lineselect \
      --set FORCE_COLOR 2 \
      --add-flags $out/lib/node_modules/lineselect/dist/cli.js
  '';

  meta = with lib; {
    description = "Shell utility to interactively select lines from stdin";
    homepage = "https://github.com/chfritz/lineselect";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lineselect";
  };
}
