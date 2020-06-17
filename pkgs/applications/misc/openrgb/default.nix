{ mkDerivation, lib, fetchFromGitHub, qmake, libusb1, hidapi }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "0b1mkp4ca4gdzk020kp6dkd3i9a13h4ikrn3417zscsvv5y9kv0s";
  };

  nativeBuildInputs = [ qmake ];
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
