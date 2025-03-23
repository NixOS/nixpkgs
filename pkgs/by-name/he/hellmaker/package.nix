{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "hellmaker";
  version = "0-unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "0xNinjaCyclone";
    repo = "hellMaker";
    rev = "2e9efe2aed9412f67a8606544392a2df10d3a2d0";
    hash = "sha256-zbtzlYGCLW/lt7GJvMHao/MZhdghNBQCQsjUImL1RC4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/hellmaker}
    cp -R * $out/share/hellmaker
    makeWrapper ${python3.interpreter} $out/bin/hellmaker \
      --set PYTHONPATH "$PYTHONPATH:$out/share/hellmaker/hellMaker.py" \
      --add-flags "$out/share/hellmaker/hellMaker.py"
    runHook postInstall
  '';

  meta = {
    description = "Generate FUD backdoors";
    homepage = "https://github.com/0xNinjaCyclone/hellMaker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "hellmaker";
    platforms = lib.platforms.all;
  };
}
