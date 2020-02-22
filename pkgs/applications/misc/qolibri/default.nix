{ mkDerivation, lib, fetchFromGitHub, pkgconfig, cmake, libeb, lzo
, qtbase, qtmultimedia, qttools, qtwebengine }:

mkDerivation {
  pname = "qolibri";
  version = "2019-07-22";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "qolibri";
    rev = "b58f9838d39300cba444eba725a369181c5d746b";
    sha256 = "0kcc6dvbcmq9y7hk8mp23pydiaqz6f0clg64d1f2y04ppphmah42";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    libeb lzo qtbase qtmultimedia qttools qtwebengine
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://github.com/ludios/qolibri;
    description = "EPWING reader for viewing Japanese dictionaries";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
  };
}
