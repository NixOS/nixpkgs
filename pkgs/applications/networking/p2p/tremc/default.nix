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
python3Packages.buildPythonPackage rec {
  version = "0.9.1";
  pname = "tremc";

  src = fetchFromGitHub {
    owner = "tremc";
    repo = pname;
    rev = "0.9.1";
    sha256 = "1yhwvlcyv1s830p5a7q5x3mkb3mbvr5cn5nh7y62l5b6iyyynlvm";
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
    license = licenses.gpl3;
  };
}
