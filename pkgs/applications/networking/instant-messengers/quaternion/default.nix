{ mkDerivation, lib, fetchgit, qtbase, qtquickcontrols, cmake }:

mkDerivation rec {
  name = "quaternion-git-${version}";
  version = "2017-10-07";

  # quaternion and tensor share the same libqmatrixclient library as a git submodule
  #
  # As all 3 projects are in very early stages, we simply load the submodule.
  #
  # At some point in the future, we should separate out libqmatrixclient into its own
  # derivation.

  src = fetchgit {
    url             = "https://github.com/QMatrixClient/Quaternion.git";
    rev             = "1007f2ca4ad5e8cc5dba437d6a0cdea07d1f1332";
    sha256          = "0hvc81ld7fcwyrxsr2q3yvzh0rzhgmflby4nmyzcbjds7b7pv0xq";
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
