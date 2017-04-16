{ stdenv, fetchgit, qtbase, qtquickcontrols, cmake, makeQtWrapper }:

stdenv.mkDerivation rec {
  name = "quaternion-git-${version}";
  version = "2017-04-15";

  # quaternion and tensor share the same libqmatrixclient library as a git submodule
  #
  # As all 3 projects are in very early stages, we simply load the submodule.
  #
  # At some point in the future, we should separate out libqmatrixclient into its own
  # derivation.

  src = fetchgit {
    url             = "https://github.com/Fxrh/Quaternion.git";
    rev             = "c35475a6755cdb75e2a6c8ca5b943685d07d9707";
    sha256          = "0cm5j4vdnp5cljfnv5jqf89ccymspaqc6j9bb4c1x891vr42np0m";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  buildInputs = [ qtbase qtquickcontrols ];
  nativeBuildInputs = [ cmake makeQtWrapper ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  postInstall = ''
    wrapQtProgram $out/bin/quaternion

    substituteInPlace $out/share/applications/quaternion.desktop \
      --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
  '';

  meta = with stdenv.lib; {
    homepage = https://matrix.org/docs/projects/client/quaternion.html;
    description = "Cross-platform desktop IM client for the Matrix protocol";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
