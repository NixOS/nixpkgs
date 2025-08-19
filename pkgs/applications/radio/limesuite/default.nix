{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
  wxGTK32,
  libusb1,
  soapysdr,
  mesa_glu,
  libX11,
  gnuplot,
  fltk,
  withGui ? false,
}:

stdenv.mkDerivation rec {
  pname = "limesuite";
  version = "23.11.0";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "sha256-f1cXrkVCIc1MqTvlCUBFqzHLhIVueybVxipNZRlF2gE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ]
  ++ lib.optional (!withGui) "-DENABLE_GUI=OFF";

  buildInputs = [
    libusb1
    sqlite
    gnuplot
    libusb1
    soapysdr
  ]
  ++ lib.optionals withGui [
    fltk
    libX11
    mesa_glu
    wxGTK32
  ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d ../udev-rules/64-limesuite.rules
    install -Dm444 -t $out/share/limesuite bin/Release/lms7suite_mcu/*
  '';

  meta = with lib; {
    description = "Driver and GUI for LMS7002M-based SDR platforms";
    homepage = "https://github.com/myriadrf/LimeSuite";
    license = licenses.asl20;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
    badPlatforms = lib.optionals withGui platforms.darwin; # withGui transitively depends on mesa, which is broken on darwin
  };
}
