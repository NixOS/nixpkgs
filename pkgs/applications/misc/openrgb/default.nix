{ mkDerivation, lib, fetchFromGitHub, qmake, libusb1, hidapi, pkg-config }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "1931aisdahjr99d4qqk824ib4x19mvhqgqmkm3j6fc5zd2hnw87m";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ libusb1 hidapi ];

  installPhase = ''
    mkdir -p $out/bin
    cp OpenRGB $out/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/OpenRGB --help > /dev/null
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    maintainers = with maintainers; [ jonringer ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
