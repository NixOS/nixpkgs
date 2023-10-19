{ lib, stdenv, fetchFromGitHub, cmake
, fetchpatch
, sqlite, wxGTK32, libusb1, soapysdr
, mesa_glu, libX11, gnuplot, fltk
, GLUT
, withGui ? !stdenv.isDarwin # withGui transitively depends on mesa, which is broken on darwin
}:

stdenv.mkDerivation rec {
  pname = "limesuite";
  version = "22.09.1";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "sha256-t3v2lhPZ1L/HRRBwA3k1KfIpih6R4TUmBWaIm8sVGdY=";
  };

  patches = [
    # Pull gcc-13 fix pending upstream inclusion:
    #   https://github.com/myriadrf/LimeSuite/pull/384
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/myriadrf/LimeSuite/commit/4ab51835d0fde4ffe6b7be2ac3dfa915e7d4d26e.patch";
      hash = "sha256-53nLeluMtTPXxchbpftPE8Z1QMyi0UKp+0nRF4ufUgo=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ] ++ lib.optional (!withGui) "-DENABLE_GUI=OFF";

  buildInputs = [
    libusb1
    sqlite
    gnuplot
    libusb1
    soapysdr
  ] ++ lib.optionals stdenv.isDarwin [
    GLUT
  ] ++ lib.optionals withGui [
    fltk
    libX11
    mesa_glu
    wxGTK32
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

