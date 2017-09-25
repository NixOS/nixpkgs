{ stdenv, fetchFromGitHub, pkgconfig, libX11, ncurses, libXext, libXft, fontconfig }:

with stdenv.lib;

let
  version = "0.7.1";
  name = "xst-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "neeasade";
    repo = "xst";
    rev = "v${version}";
    sha256 = "1fh4y2w0icaij99kihl3w8j5d5b38d72afp17c81pi57f43ss6pc";
  };

  buildInputs = [ pkgconfig libX11 ncurses libXext libXft fontconfig ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = https://github.com/neeasade/xst;
    description = "Simple terminal fork that can load config from Xresources";
    license = licenses.mit;
    maintainers = maintainers.vyp;
    platforms = platforms.linux;
  };
}
