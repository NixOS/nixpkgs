{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, cmake
, qtquickcontrols
, qtquickcontrols2
, qtkeychain
, qtmultimedia
, qttools
, libquotient
, libsecret
}:

mkDerivation rec {
  pname = "quaternion";
  version = "0.0.95.1";

  src = fetchFromGitHub {
    owner = "QMatrixClient";
    repo = "Quaternion";
    rev = version;
    sha256 = "sha256-6FLj/hVY13WO7sMgHCHV57eMJu39cwQHXQX7m0lmv4I=";
  };

  buildInputs = [
    qtmultimedia
    qtquickcontrols2
    qtkeychain
    libquotient
    libsecret
  ];

  nativeBuildInputs = [ cmake qttools ];

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
