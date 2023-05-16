{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, libX11
, libXext
, libXft
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "xst";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-V7WzletBFOOXBXClDJZIGT2comnC5WDApO1ZCoPKThY=";
=======
    sha256 = "nOJcOghtzFkl7B/4XeXptn2TdrGQ4QTKBo+t+9npxOA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libX11
    libXext
    libXft
    ncurses
  ];

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/gnotclub/xst";
    description = "Simple terminal fork that can load config from Xresources";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
