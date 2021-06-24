{ lib, stdenv, fetchFromGitHub, cmake
, sqlite, wxGTK30-gtk3, libusb1, soapysdr
, mesa_glu, libX11, gnuplot, fltk
} :

stdenv.mkDerivation rec {
  pname = "limesuite";
  version = "20.10.0";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "04wzfhzqmxjsa6bgcr4zd518fln9rbwnbabf48kha84d70vzkdlx";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  buildInputs = [
    libusb1
    sqlite
    wxGTK30-gtk3
    fltk
    gnuplot
    libusb1
    soapysdr
    mesa_glu
    libX11
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
    platforms = platforms.linux;
  };
}

