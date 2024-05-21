{ lib
, stdenv
, fetchFromBitbucket
, wrapQtAppsHook
, pkg-config
, hamlib
, libusb1
, cmake
, gfortran
, fftw
, fftwFloat
, qtbase
, qtmultimedia
, qtserialport
}:

stdenv.mkDerivation rec {
  pname = "js8call";
  version = "2.2.0";

  src = fetchFromBitbucket {
    owner = "widefido";
    repo = pname;
    rev = "v${version}-ga";
    sha256 = "sha256-mFPhiAAibCiAkLrysAmIQalVCGd9ips2lqbAsowYprY=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    gfortran
    pkg-config
    cmake
  ];

  buildInputs = [
    hamlib
    libusb1
    fftw
    fftwFloat
    qtbase
    qtmultimedia
    qtserialport
  ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/share/applications" "$out/share/applications" \
        --replace "/usr/share/pixmaps" "$out/share/pixmaps" \
        --replace "/usr/bin/" "$out/bin"
  '';

  patches = [ ./cmake.patch ];

  meta = with lib; {
    description = "Weak-signal keyboard messaging for amateur radio";
    longDescription = ''
      JS8Call is software using the JS8 Digital Mode providing weak signal
      keyboard to keyboard messaging to Amateur Radio Operators.
    '';
    homepage = "http://js8call.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
