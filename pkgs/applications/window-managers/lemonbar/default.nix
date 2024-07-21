{ lib, stdenv, fetchFromGitHub, perl, libxcb }:

stdenv.mkDerivation rec {
  pname = "lemonbar";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "LemonBoy";
    repo = "bar";
    rev = "v${version}";
    sha256 = "sha256-OLhgu0kmMZhjv/VST8AXvIH+ysMq72m4TEOypdnatlU=";
  };

  buildInputs = [ libxcb perl ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "Lightweight xcb based bar";
    homepage = "https://github.com/LemonBoy/bar";
    maintainers = with maintainers; [ meisternu moni ];
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "lemonbar";
  };
}
