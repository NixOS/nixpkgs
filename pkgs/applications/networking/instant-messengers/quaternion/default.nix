{ stdenv, lib, fetchFromGitHub, qtbase, qtquickcontrols, cmake, libqmatrixclient }:

stdenv.mkDerivation rec {
  name = "quaternion-${version}";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "Quaternion";
    rev    = "v${version}";
    sha256 = "0zdpll953a7biwnklhgmgg3k2vz7j58lc1nmfkmvsfcj1fmdf408";
  };

  buildInputs = [ qtbase qtquickcontrols libqmatrixclient ];

  nativeBuildInputs = [ cmake ];

  # libqmatrixclient is now compiled as a dynamic library but quarternion cannot use it yet
  # https://github.com/QMatrixClient/Quaternion/issues/239
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
