{ stdenv, fetchFromGitHub, cmake
, sqlite, wxGTK30, libusb1, soapysdr
, mesa_glu, libX11, gnuplot, fltk
} :

let
  version = "19.04.0";

in stdenv.mkDerivation {
  pname = "limesuite";
  inherit version;

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "1lrjrli0ny25qwg8bw1bvbdb18hf7ffqj4ziibkgzscv3w5v0s45";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libusb1
    sqlite
    wxGTK30
    fltk
    gnuplot
    libusb1
    soapysdr
    mesa_glu
    libX11
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp ../udev-rules/64-limesuite.rules $out/lib/udev/rules.d

    mkdir -p $out/share/limesuite
    cp bin/Release/lms7suite_mcu/* $out/share/limesuite
  '';

  meta = with stdenv.lib; {
    description = "Driver and GUI for LMS7002M-based SDR platforms";
    homepage = https://github.com/myriadrf/LimeSuite;
    license = licenses.asl20;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

