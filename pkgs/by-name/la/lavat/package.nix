{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  version = "2.1.0";
in
stdenv.mkDerivation {
  pname = "lavat";
  inherit version;

  src = fetchFromGitHub {
    owner = "AngelJumbo";
    repo = "lavat";
    rev = "v${version}";
    hash = "sha256-wGtuYgZS03gXYgdNdugGu/UlROQTrQ3C1inJ/aTUBKk=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp lavat $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lava lamp simulation in the terminal";
    longDescription = ''
      Lavat puts ascii metaballs in your terminal to make it look a bit like a
      lava lamp.

      Lavat contains various options, including those to change the color and
      speed of the metaballs. For a full list, run `lavat -h`
    '';
    maintainers = [ maintainers.minion3665 ];
    license = licenses.mit;
    homepage = "https://github.com/AngelJumbo/lavat";
    platforms = platforms.all;
    mainProgram = "lavat";
  };
}
