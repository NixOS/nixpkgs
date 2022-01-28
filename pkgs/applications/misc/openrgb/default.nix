{ lib, mkDerivation, fetchFromGitLab, qmake, libusb1, hidapi, pkg-config, coreutils, mbedtls }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.7";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "0xhfaz0b74nfnh7il2cz5c0338xlzay00g6hc2h3lsncarj8d5n7";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ libusb1 hidapi mbedtls ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp openrgb $out/bin

    substituteInPlace 60-openrgb.rules \
      --replace /bin/chmod "${coreutils}/bin/chmod"

    mkdir -p $out/etc/udev/rules.d
    cp 60-openrgb.rules $out/etc/udev/rules.d

    install -Dm444 -t "$out/share/applications" qt/OpenRGB.desktop
    install -Dm444 -t "$out/share/icons/hicolor/128x128/apps" qt/OpenRGB.png

    runHook postInstall
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
