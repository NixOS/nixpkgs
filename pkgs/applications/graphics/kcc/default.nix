{ lib
, mkDerivationWith
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, p7zip
, archiveSupport ? true
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "kcc";
  version = "5.5.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version;
    pname = "KindleComicConverter";
    sha256 = "5dbee5dc5ee06a07316ae5ebaf21ffa1970094dbae5985ad735e2807ef112644";
  };

  propagatedBuildInputs = with python3Packages ; [
    pillow
    pyqt5
    psutil
    python-slugify
    raven
  ];

  qtWrapperArgs = lib.optionals archiveSupport [ "--prefix" "PATH" ":" "${ lib.makeBinPath [ p7zip ] }" ];

<<<<<<< HEAD
  postFixup = ''
=======
  postFixup =  ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $out/bin/kcc "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Python app to convert comic/manga files or folders to EPUB, Panel View MOBI or E-Ink optimized CBZ";
    homepage = "https://kcc.iosphe.re";
    license = licenses.isc;
    maintainers = with maintainers; [ dawidsowa ];
  };
}
