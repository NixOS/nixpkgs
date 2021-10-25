{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "your-editor";
  version = "1203";

  src = fetchFromGitHub {
    owner = "kammerdienerb";
    repo = "yed";
    rev = "608418f2037dc4ef5647e69fcef45302c50f138c";
    sha256 = "KqK2lcDTn91aCFJIDg+h+QsTrl7745So5aiKCxPkeh4=";
  };

  installPhase = ''
    runHook preInstall
    patchShebangs install.sh
    ./install.sh -p $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Your-editor (yed) is a small and simple terminal editor core that is meant to be extended through a powerful plugin architecture";
    homepage = "https://your-editor.org/";
    license = with licenses; [ mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ uniquepointer ];
    mainProgram = "yed";
  };
}
