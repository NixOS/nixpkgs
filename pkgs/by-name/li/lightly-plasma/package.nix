{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "lightly-plasma";
  version = "0-unstable-2022-08-27";

  src = fetchFromGitHub {
    owner = "doncsugar";
    repo = "lightly-plasma";
    rev = "475c1d4f00b785a117abe0d9cfca2b2c78fdd968";
    hash = "sha256-4MVFW0orTr1XWdEtsD2Uw/cWUkmCPxin3gS4mscvz/E=";
  };

  buildPhase = ''
    runHook preBuild

    bash genThemes.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/plasma/desktoptheme"
    cp -r output/* "$out/share/plasma/desktoptheme"

    runHook postInstall
  '';

  meta = {
    description = "A Plasma Style for the Lightly Application Style ";
    homepage = "https://www.pling.com/p/1879921";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hacker1024 ];
  };
}

