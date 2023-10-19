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

stdenv.mkDerivation rec {
  pname = "quaternion";
  version = "0.0.96-beta4";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "Quaternion";
    rev = "refs/tags/${version}";
    hash = "sha256-yItl31Ze48lRIIey+FlRLMVAkg4mHu8G1sFOceHvTJw=";
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

  cmakeFlags = [
    "-DBUILD_WITH_QT6=OFF"
  ];

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
    homepage = "https://matrix.org/ecosystem/clients/quaternion/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtquickcontrols2.meta) platforms;
  };
}
