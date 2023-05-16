{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "your-editor";
<<<<<<< HEAD
  version = "1506";
=======
  version = "1505";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "your-editor";
    repo = "yed";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-QmUquXoDGhoan+Y1kdkTirdkIvYPBkeAEkMLkaE9QKk=";
=======
    sha256 = "sha256-4HPrBr1M8J484qu1cXpZyVdLu3+/IYoNnNV9vSd4SlY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/your-editor/yed/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ uniquepointer ];
    mainProgram = "yed";
  };
}
