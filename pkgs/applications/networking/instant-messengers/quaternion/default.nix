{ stdenv, lib, fetchFromGitHub, qtbase, qtquickcontrols, cmake, libqmatrixclient }:

stdenv.mkDerivation rec {
  name = "quaternion-${version}";
  version = "0.0.5";

  # libqmatrixclient doesn't support dynamic linking as of 0.2 so we simply pull in the source

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "Quaternion";
    rev    = "v${version}";
    sha256 = "14xmaq446aggqhpcilahrw2mr5gf2mlr1xzyp7r6amrnmnqsyxrd";
  };

  buildInputs = [ qtbase qtquickcontrols libqmatrixclient ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  # take the source from libqmatrixclient
  postPatch = ''
    rm -rf lib
    ln -s ${libqmatrixclient.src} lib
  '';

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
