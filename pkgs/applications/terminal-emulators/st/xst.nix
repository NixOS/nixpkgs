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
  version = "0.8.4.1";

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = pname;
    rev = "v${version}";
    sha256 = "nOJcOghtzFkl7B/4XeXptn2TdrGQ4QTKBo+t+9npxOA=";
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
