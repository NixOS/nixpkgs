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
  version = "0.9.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "tremc";
    repo = pname;
    rev = version;
    hash = "sha256-219rntmetmj1JFG+4NyYMFTWmrHKJL7fnLoMIvnTP4Y=";
  };

  patches = [
    # Remove when tremc > 0.9.3 is released
    (fetchpatch {
      url = "https://github.com/tremc/tremc/commit/a8aaf9a6728a9ef3d8f13b3603456b0086122891.patch";
      hash = "sha256-+HYdWTbcpvZqjshdHLZ+Svmr6U/aKFc3sy0aka6rn/A=";
      name = "support-transmission-4.patch";
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
  lib.optional useGeoIP geoip;

  dontBuild = true;
  doCheck = false;

  makeWrapperArgs = ["--prefix PATH : ${lib.escapeShellArg wrapperPath}"];

  installPhase = ''
    make DESTDIR=$out install
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Curses interface for transmission";
    mainProgram = "tremc";
    homepage = "https://github.com/tremc/tremc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kashw2 ];
  };
}
