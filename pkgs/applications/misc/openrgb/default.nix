{ lib, stdenv, fetchFromGitLab, qmake, wrapQtAppsHook, libusb1, hidapi, pkg-config, coreutils, mbedtls_2, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "openrgb";
  version = "0.8";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "sha256-46dL1D5oVlw6mNuFDCbbrUDmq42yFXV/qFJ1JnPT5/s=";
  };

  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];
  buildInputs = [ libusb1 hidapi mbedtls_2 qtbase qttools ];

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace /bin/chmod "${coreutils}/bin/chmod"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
  '';

  meta = with lib; {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    maintainers = with maintainers; [ jonringer ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
