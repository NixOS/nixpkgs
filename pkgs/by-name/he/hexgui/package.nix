{
  ant,
  fetchFromGitHub,
  jdk,
  lib,
  makeWrapper,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "hexgui";
  version = "0.10-unstable-2024-11-03";

  src = fetchFromGitHub {
    owner = "selinger";
    repo = "hexgui";
    rev = "444408f4411a4f13cbd90ac670f1dd344d35a948";
    hash = "sha256-W5klRwVsSlrSp3Pw5D4uknIRjaNMv+OTUtXXTmd6P3I=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
  ];
  buildPhase = ''
    ant
  '';

  installPhase = ''
    mkdir $out
    mv bin lib $out
    wrapProgram $out/bin/hexgui --prefix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  meta = {
    description = "GUI for the board game Hex";
    mainProgram = "hexgui";
    homepage = "https://github.com/selinger/hexgui";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.ursi ];
  };
}
