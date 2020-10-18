{ stdenv, fetchFromGitHub, python3Packages
, x11Support ? !stdenv.isDarwin
, xclip ? null
, pbcopy ? null
, useGeoIP ? false # Require /var/lib/geoip-databases/GeoIP.dat
}:
let
  wrapperPath = with stdenv.lib; makeBinPath (
    optional x11Support xclip ++
    optional stdenv.isDarwin pbcopy
  );
in
python3Packages.buildPythonApplication rec {
  pname = "tremc";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "tremc";
    repo = pname;
    rev = version;
    sha256 = "1fqspp2ckafplahgba54xmx0sjidx1pdzyjaqjhz0ivh98dkx2n5";
  };

  buildInputs = with python3Packages; [
    python
    wrapPython
  ];

  pythonPath = with python3Packages; [
    ipy
    pyperclip
  ] ++
  stdenv.lib.optional useGeoIP GeoIP;

  phases = [ "unpackPhase" "installPhase" ];

  makeWrapperArgs = ["--prefix PATH : ${wrapperPath}"];

  installPhase = ''
    make DESTDIR=$out install
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Curses interface for transmission";
    homepage = "https://github.com/tremc/tremc";
    license = licenses.gpl3Plus;
  };
}
