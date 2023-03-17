{ lib, stdenv
, fetchFromGitHub
, pkg-config
, gd, ncurses
, sqlite
, check
}:

stdenv.mkDerivation rec {
  pname = "vnstat";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "vergoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XBApdQA6E2mx9WPIEiY9z2vxJS3qR0mjBnhbft4LNuQ=";
  };

  postPatch = ''
    substituteInPlace src/cfg.c --replace /usr/local $out
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gd ncurses sqlite ];

  nativeCheckInputs = [ check ];

  doCheck = true;

  meta = with lib; {
    description = "Console-based network statistics utility for Linux";
    longDescription = ''
      vnStat is a console-based network traffic monitor for Linux and BSD that
      keeps a log of network traffic for the selected interface(s). It uses the
      network interface statistics provided by the kernel as information source.
      This means that vnStat won't actually be sniffing any traffic and also
      ensures light use of system resources.
    '';
    homepage = "https://humdi.net/vnstat/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evils ];
  };
}
