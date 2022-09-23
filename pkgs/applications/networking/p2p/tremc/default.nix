{ lib, stdenv, fetchFromGitHub, fetchpatch, python3Packages
, x11Support ? !stdenv.isDarwin
, xclip ? null
, pbcopy ? null
, useGeoIP ? false # Require /var/lib/geoip-databases/GeoIP.dat
}:
let
  wrapperPath = with lib; makeBinPath (
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

  patches = [
    # Remove when version >0.9.2 is released
    (fetchpatch {
      url = "https://github.com/tremc/tremc/commit/bdffff2bd76186a4e3488b83f719fc7f7e3362b6.patch";
      sha256 = "1zip2skh22v0yyv2hmszxn5jshp9m1jpw0fsyfvmqfxzq7m3czy5";
      name = "replace-decodestring-with-decodebytes.patch";
    })
  ];

  buildInputs = with python3Packages; [
    python
    wrapPython
  ];

  pythonPath = with python3Packages; [
    ipy
    pyperclip
  ] ++
  lib.optional useGeoIP GeoIP;

  dontBuild = true;
  doCheck = false;

  makeWrapperArgs = ["--prefix PATH : ${lib.escapeShellArg wrapperPath}"];

  installPhase = ''
    make DESTDIR=$out install
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Curses interface for transmission";
    homepage = "https://github.com/tremc/tremc";
    license = licenses.gpl3Plus;
  };
}
