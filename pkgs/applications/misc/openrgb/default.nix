{ mkDerivation, lib, fetchFromGitHub, qmake, libusb1, hidapi, pkg-config, fetchpatch }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "sha256-tHrRG2Zx7NYqn+WPiRpAlWA/QmxuAYidENanTkC1XVw";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ libusb1 hidapi ];

  patches = [
    # Make build SOURCE_DATE_EPOCH aware, merged in master
    (fetchpatch {
      url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/commit/f1b7b8ba900db58a1119d8d3e21c1c79de5666aa.patch";
      sha256 = "17m1hn1kjxfcmd4p3zjhmr5ar9ng0zfbllq78qxrfcq1a0xrkybx";
    })
  ];

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
