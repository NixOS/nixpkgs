{ lib, stdenv, fetchFromGitHub, pkg-config, libX11, ncurses, libXext, libXft, fontconfig }:

stdenv.mkDerivation rec {
  pname = "xst";
  version = "0.8.4.1";

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = pname;
    rev = "v${version}";
    sha256 = "nOJcOghtzFkl7B/4XeXptn2TdrGQ4QTKBo+t+9npxOA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 ncurses libXext libXft fontconfig ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "https://github.com/gnotclub/xst";
    description = "Simple terminal fork that can load config from Xresources";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
