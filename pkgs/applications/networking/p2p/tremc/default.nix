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
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "other";

  src = fetchFromGitHub {
    owner = "tremc";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-219rntmetmj1JFG+4NyYMFTWmrHKJL7fnLoMIvnTP4Y=";
  };

  patches = [
    # Remove when tremc > 0.9.3 is released
    (fetchpatch {
      url = "https://github.com/tremc/tremc/commit/a8aaf9a6728a9ef3d8f13b3603456b0086122891.patch";
      hash = "sha256-+HYdWTbcpvZqjshdHLZ+Svmr6U/aKFc3sy0aka6rn/A=";
      name = "support-transmission-4.patch";
=======
    sha256 = "1fqspp2ckafplahgba54xmx0sjidx1pdzyjaqjhz0ivh98dkx2n5";
  };

  patches = [
    # Remove when version >0.9.2 is released
    (fetchpatch {
      url = "https://github.com/tremc/tremc/commit/bdffff2bd76186a4e3488b83f719fc7f7e3362b6.patch";
      sha256 = "1zip2skh22v0yyv2hmszxn5jshp9m1jpw0fsyfvmqfxzq7m3czy5";
      name = "replace-decodestring-with-decodebytes.patch";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "https://github.com/tremc/tremc";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ kashw2 ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
