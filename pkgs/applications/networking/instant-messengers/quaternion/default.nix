{ stdenv
, lib
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
, qtquickcontrols2
, qtkeychain
, qtmultimedia
, qttools
, libquotient
, libsecret
, olm
}:

stdenv.mkDerivation {
  pname = "quaternion";
  version = "0.0.95.81";

  src = fetchFromGitHub {
    owner = "QMatrixClient";
    repo = "Quaternion";
    rev = "5f639d8c84ed1475057b2cb3f7d0cb0abe77203b";
    hash = "sha256-/1fich97oqSSDpfOjaYghYzHfu3MDrh77nanbIN/v/w=";
  };

  buildInputs = [
    libquotient
    libsecret
    olm
    qtbase
    qtkeychain
    qtmultimedia
    qtquickcontrols2
  ];

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];

  postInstall =
    if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      mv $out/bin/quaternion.app $out/Applications
      rmdir $out/bin || :
    '' else ''
      substituteInPlace $out/share/applications/com.github.quaternion.desktop \
        --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
    '';

  meta = with lib; {
    description = "Cross-platform desktop IM client for the Matrix protocol";
    homepage = "https://matrix.org/docs/projects/client/quaternion.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtquickcontrols2.meta) platforms;
  };
}
