{ lib
, mkDerivation
, fetchgit
, qmake
, alsaLib
, libusb1
}:

mkDerivation rec {
  pname = "IConnConfig";
  version = "0.5.2-beta";
  src = fetchgit {
    url = "https://codeberg.org/dehnhardt/IConnConfig";
    rev = "v${version}";
    sha256 = "10g0cgqkpqgwnbjdndhmyk4h680kbmlws3mc678fmgjy75qvbfmj";
  };

  PKControls = fetchgit {
    url = "https://codeberg.org/dehnhardt/PKControls.git";
    rev = "f49a0105b65c19e3f63962a1e242839be15bc6b6";
    sha256 = "1n6lkqy9ihqffs1s2ihdzzhk7dxi1cjj4igs3m00m8h0b5g78gga";
  };

  sourceRoot = "source/iconnconfig";

  unpackPhase = ''
    mkdir -p ${sourceRoot} source/PKControls
    cp -r ${src}/* ${sourceRoot}
    cp -r ${PKControls}/* source/PKControls
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [ alsaLib libusb1 ];

  qmakeFlags = [ "iConnConfig.pro" "CONFIG+=build_deb" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dehnhardt/IConnConfig";
    description = "Linux based configuration utility for IConnectivity interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ ezemtsov ];
    platforms = platforms.linux;
  };
}
