{ lib, stdenv
, fetchFromGitHub
, pkg-config
, gd, ncurses
, sqlite
, check
}:

stdenv.mkDerivation rec {
  pname = "vnstat";
<<<<<<< HEAD
  version = "2.11";
=======
  version = "2.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vergoh";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-IO5B+jyY6izPpam3Qt4Hu8BOGwfO10ER/GFEbsQORK0=";
=======
    sha256 = "sha256-XBApdQA6E2mx9WPIEiY9z2vxJS3qR0mjBnhbft4LNuQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
