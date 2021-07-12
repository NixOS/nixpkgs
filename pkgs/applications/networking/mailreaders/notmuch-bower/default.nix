{ lib, stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme }:

stdenv.mkDerivation rec {
  pname = "notmuch-bower";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    rev = version;
    sha256 = "0hvvlbvad6h73iiyn9xshlj073p2ddchgh0pyizh9gi8niir4fn5";
  };

  nativeBuildInputs = [ gawk mercury pandoc ];

  buildInputs = [ ncurses gpgme ];

  makeFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  installPhase = ''
    mkdir -p $out/bin
    mv bower $out/bin/
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/wangp/bower";
    description = "A curses terminal client for the Notmuch email system";
    maintainers = with maintainers; [ erictapen ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
