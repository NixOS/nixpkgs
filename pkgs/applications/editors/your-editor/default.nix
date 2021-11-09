{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "your-editor";
  version = "1206";

  src = fetchFromGitHub {
    owner = "kammerdienerb";
    repo = "yed";
    rev = "6cdd99fe1359899b26d8967bd376fd5caa5451eb";
    sha256 = "0XECSolW/xPXd1v3sv9HbJMWuHGnwCOwmHoPNCUsE+w=";
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
