{ mkDerivation, lib, fetchgit, qtbase, qtquickcontrols, cmake }:

mkDerivation rec {
  name = "quaternion-git-${version}";
  version = "2017-06-29";

  # quaternion and tensor share the same libqmatrixclient library as a git submodule
  #
  # As all 3 projects are in very early stages, we simply load the submodule.
  #
  # At some point in the future, we should separate out libqmatrixclient into its own
  # derivation.

  src = fetchgit {
    url             = "https://github.com/QMatrixClient/Quaternion.git";
    rev             = "1febc0178fd3d02b7426f58981b54924ad60c84d";
    sha256          = "1whjhlphdhk7kgw2zqc0wj3k2i9gkp79qq2bnrh4mbcp3qmcqngr";
    fetchSubmodules = true;
  };

  buildInputs = [ qtbase qtquickcontrols ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/quaternion.desktop \
      --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
  '';

  meta = with lib; {
    description = "Cross-platform desktop IM client for the Matrix protocol";
    homepage    = https://matrix.org/docs/projects/client/quaternion.html;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
