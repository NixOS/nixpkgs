{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2.2.0";
in
stdenv.mkDerivation {
  pname = "lavat";
  inherit version;

  src = fetchFromGitHub {
    owner = "AngelJumbo";
    repo = "lavat";
    rev = "v${version}";
    hash = "sha256-SNRhel2RmaAPqoYpcq7F9e/FcbCJ0E3VJN/G9Ya4TeY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp lavat $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Lava lamp simulation in the terminal";
    longDescription = ''
      Lavat puts ascii metaballs in your terminal to make it look a bit like a
      lava lamp.

      Lavat contains various options, including those to change the color and
      speed of the metaballs. For a full list, run `lavat -h`
    '';
    maintainers = [ lib.maintainers.minion3665 ];
    license = lib.licenses.mit;
    homepage = "https://github.com/AngelJumbo/lavat";
    platforms = lib.platforms.all;
    mainProgram = "lavat";
  };
}
