{
  lib,
  clangStdenv,
  fetchFromGitHub,
  debug ? false,
}:

let
  pname = if debug then "rayforce-debug" else "rayforce";
  version = "0-unstable-2025-11-10";
  rev = "0d3f37c";
  hash = "sha256-3vgSC3BE2mxSp0EQtHUUzlNsXKjwnxgB6U83wTI0buU=";
in
clangStdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    inherit rev hash;
    owner = "singaraiona";
    repo = "rayforce";
  };

  buildFlags = [
    (if debug then "debug" else "release")
  ];

  doCheck = true;
  checkTarget = [ "tests" ];

  installPhase = ''
    mkdir -p $out/bin
    cp rayforce $out/bin
  '';

  meta = {
    description = "Fast columnar database";
    homepage = "https://github.com/singaraiona/rayforce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ProducerMatt ];
    mainProgram = "rayforce";
    platforms = lib.platforms.x86_64;
  };
}
