{ stdenv, fetchFromGitHub
, cmake , pkgconfig, libusb
}:

let
  version = "1.0.9";
in
  stdenv.mkDerivation {
    name = "airspy-${version}";

    src = fetchFromGitHub {
      owner = "airspy";
      repo = "airspyone_host";
      rev = "v${version}";
      sha256 = "04kx2p461sqd4q354n1a99zcabg9h29dwcnyhakykq8bpg3mgf1x";
    };

    postPatch = ''
      substituteInPlace airspy-tools/CMakeLists.txt --replace "/etc/udev/rules.d" "$out/etc/udev/rules.d"
    '';

    nativeBuildInputs = [ cmake pkgconfig ];
    buildInputs = [ libusb ];

    cmakeFlags = [ "-DINSTALL_UDEV_RULES=ON" ];

    meta = with stdenv.lib; {
      homepage = http://github.com/airspy/airspyone_host;
      description = "Host tools and driver library for the AirSpy SDR";
      license = licenses.free;
      platforms = platforms.linux;
      maintainers = with maintainers; [ markuskowa ];
    };
  }
