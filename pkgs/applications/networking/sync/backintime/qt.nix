{ mkDerivation, backintime-common, python3 }:

let
<<<<<<< HEAD
  python' = python3.withPackages (ps: with ps; [ pyqt5 backintime-common packaging ]);
=======
  python' = python3.withPackages (ps: with ps; [ pyqt5 backintime-common ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
mkDerivation {
  inherit (backintime-common)
    version src installFlags meta dontAddPrefix nativeBuildInputs;

  pname = "backintime-qt";

  buildInputs = [ python' backintime-common ];

  preConfigure = ''
    cd qt
    substituteInPlace configure \
      --replace '"/../etc' '"/etc'
    substituteInPlace qttools.py \
      --replace "__file__, os.pardir, os.pardir" '"${backintime-common}/${python'.sitePackages}/backintime"'
  '';

  preFixup = ''
    wrapQtApp "$out/bin/backintime-qt" \
      --prefix PATH : "${backintime-common}/bin:$PATH"
  '';
}
