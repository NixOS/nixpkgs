{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "kreative-square-fonts";
  version = "unstable-2021-01-29";

  src = fetchFromGitHub {
    owner = "kreativekorp";
    repo = "open-relay";
    rev = "084f05af3602307499981651eca56851bec01fca";
    hash = "sha256-+ihosENczaGal3BGDIaJ/de0pf8txdtelSYMxPok6ww=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype/ KreativeSquare/KreativeSquare.ttf
    install -Dm444 -t $out/share/fonts/truetype/ KreativeSquare/KreativeSquareSM.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fullwidth scalable monospace font designed specifically to support pseudographics, semigraphics, and private use characters";
    homepage = "https://www.kreativekorp.com/software/fonts/ksquare.shtml";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linus ];
  };
}
