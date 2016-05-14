{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "transmission-remote-cli-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/fagga/transmission-remote-cli/archive/v${version}.tar.gz";
    sha256 = "1y0hkpcjf6jw9xig8yf484hbhy63nip0pkchx401yxj81m25l4z9";
  };

  buildInputs = with pythonPackages; [ python wrapPython ];
  pythonPath = [ pythonPackages.curses ];

  installPhase = ''
    install -D transmission-remote-cli $out/bin/transmission-remote-cli
    install -D transmission-remote-cli.1 $out/share/man/man1/transmission-remote-cli.1
    wrapPythonPrograms
  '';

  meta = {
    description = "Curses interface for the Transmission BitTorrent daemon";
    homepage = https://github.com/fagga/transmission-remote-cli;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
