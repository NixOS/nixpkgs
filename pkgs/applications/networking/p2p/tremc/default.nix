{ stdenv, fetchurl, python3Packages }:

stdenv.mkDerivation rec {
  pname = "tremc";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/tremc/tremc/archive/${version}.tar.gz";
    sha256 = "0bs168hn5q6kpz5aiifmkwfwfkhjlnv6l7v29yy05h096bj3f6zc";
  };

  buildInputs = with python3Packages; [ python wrapPython ];

  buildPhase = "echo skip";

  installPhase = ''
    install -D tremc $out/bin/tremc
    install -D tremc.1 $out/share/man/man1/tremc.1
    wrapPythonPrograms
  '';

  meta = {
    description = "Curses interface for the Transmission BitTorrent daemon";
    homepage = "https://github.com/tremc/tremc";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
