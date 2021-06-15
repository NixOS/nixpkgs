{ lib, mkDerivation, fetchFromGitLab, qmake, libusb1, hidapi, pkg-config, coreutils }:

mkDerivation rec {
  pname = "openrgb";
  version = "0.6";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${version}";
    sha256 = "sha256-x/wGD39Jm/kmcTEZP3BnLXxyv/jkPOJd6mLCO0dp5wM=";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ libusb1 hidapi ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp openrgb $out/bin

    substituteInPlace 60-openrgb.rules \
      --replace /bin/chmod "${coreutils}/bin/chmod"

    mkdir -p $out/etc/udev/rules.d
    cp 60-openrgb.rules $out/etc/udev/rules.d

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
