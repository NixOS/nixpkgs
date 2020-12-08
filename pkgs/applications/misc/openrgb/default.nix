{ lib, mkDerivation, fetchFromGitLab, qmake, libusb1, hidapi, pkg-config }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.5";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "001x2ycfmlb9s21sp91aw5gxizcn6kzm8x7bvkps4b1iq0ap5fzv";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ libusb1 hidapi ];

  installPhase = ''
    mkdir -p $out/bin
    cp openrgb $out/bin

    mkdir -p $out/etc/udev/rules.d
    cp 60-openrgb.rules $out/etc/udev/rules.d
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
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
