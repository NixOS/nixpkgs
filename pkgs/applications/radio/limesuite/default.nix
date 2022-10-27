{ lib, stdenv, fetchFromGitHub, cmake
, sqlite, wxGTK32, libusb1, soapysdr
, mesa_glu, libX11, gnuplot, fltk
, GLUT
} :

stdenv.mkDerivation rec {
  pname = "limesuite";
  version = "22.09.1";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "sha256-t3v2lhPZ1L/HRRBwA3k1KfIpih6R4TUmBWaIm8sVGdY=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  buildInputs = [
    libusb1
    sqlite
    wxGTK32
    fltk
    gnuplot
    libusb1
    soapysdr
    mesa_glu
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    GLUT
  ];

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
  };
}

