{ mkDerivation, lib, qtbase, cmake, fetchFromGitHub }:

mkDerivation rec {
  pname = "evtest-qt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wfzkgq81764qzxgk0y5vvpxcrb3icvrr4dd4mj8njrqgbwmn0mw";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Simple input device tester for linux with Qt GUI";
    homepage = "https://github.com/Grumbel/evtest-qt";
    maintainers = with maintainers; [ alexarice ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
