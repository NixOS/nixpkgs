{ stdenv, emacs, ... }:

let
  # name of a package containing a .info file (bonus points if it has
  # no/few dependencies):
  emacsPackage = "dash";
  infoFile = "${emacsPackage}.info";
  emacsWithPackages =
    emacs.pkgs.withPackages (epkgs: [ epkgs.${emacsPackage} ]);
  testDirectory = "${emacsWithPackages}/share/info/";
in stdenv.mkDerivation {
  name = "emacs-with-packages-test";
  buildCommand = ''
    if ! [ -e ${testDirectory}/${infoFile} ]; then
      echo "${infoFile} should have been in ${testDirectory} but wasn't"
      exit 1
    fi

    touch $out
  '';
}
