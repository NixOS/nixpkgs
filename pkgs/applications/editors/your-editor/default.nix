{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "your-editor";
  version = "1403";

  src = fetchFromGitHub {
    owner = "your-editor";
    repo = "yed";
    rev = version;
    sha256 = "sha256-hG0ZRAxWOdFtDgKcDysu89LOdULZmJHLi7grfVjAbwM=";
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
