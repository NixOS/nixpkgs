{ mkDerivation, stdenv, lib, fetchFromGitHub, cmake
, qtbase, qtquickcontrols, qtquickcontrols2, qtkeychain, qtmultimedia, qttools
, libquotient, libsecret
}:

mkDerivation rec {
  pname = "quaternion";
  version = "0.0.9.4e";

  src = fetchFromGitHub {
    owner = "QMatrixClient";
    repo = "Quaternion";
    rev = "${version}";
    sha256 = "0hqhg7l6wpkdbzrdjvrbqymmahziri07ba0hvbii7dd2p0h248fv";
  };

  buildInputs = [
    qtbase
    qtmultimedia
    qtquickcontrols
    qtquickcontrols2
    qtkeychain
    libquotient
    libsecret
  ];

  nativeBuildInputs = [ cmake qttools ];

  postInstall = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv $out/bin/quaternion.app $out/Applications
    rmdir $out/bin || :
  '' else ''
    substituteInPlace $out/share/applications/com.github.quaternion.desktop \
      --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
  '';

  meta = with lib; {
    description =
      "Cross-platform desktop IM client for the Matrix protocol";
    homepage = "https://matrix.org/docs/projects/client/quaternion.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
