{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "f1viewer";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "SoMuchForSubtlety";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cTXueIOD+OXx4WikhdNv3v/F2/f5aDicyPP7FgTU6AM=";
  };

  vendorSha256 = "sha256-47uLx4t0N1T3zqZ9o/su/onJEUdGXpq+iVSUaRnwW3I=";

  meta = with lib; {
    description =
      "A TUI to view Formula 1 footage using VLC or another media player";
    homepage = "https://github.com/SoMuchForSubtlety/f1viewer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michzappa ];
  };
}
