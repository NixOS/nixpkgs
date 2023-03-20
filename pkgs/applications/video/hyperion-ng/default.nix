{ stdenv, avahi-compat, cmake, fetchFromGitHub, flatbuffers, hidapi, lib, libcec
, libusb1, libX11, libxcb, libXrandr, mbedtls, mkDerivation, protobuf, python3
, qtbase, qtserialport, qtsvg, qtx11extras, wrapQtAppsHook }:

mkDerivation rec {
  pname = "hyperion.ng";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "hyperion-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-J31QaWwGNhIpnZmWN9lZEI6fC0VheY5X8fGchQqtAlQ=";
  };

  buildInputs = [
    avahi-compat
    flatbuffers
    hidapi
    libcec
    libusb1
    libX11
    libxcb
    libXrandr
    mbedtls
    protobuf
    python3
    qtbase
    qtserialport
    qtsvg
    qtx11extras
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_SYSTEM_MBEDTLS_LIBS=ON"
    "-DUSE_SYSTEM_FLATBUFFERS_LIBS=ON"
    "-DUSE_SYSTEM_PROTO_LIBS=ON"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Open Source Ambilight solution";
    homepage = "https://github.com/hyperion-project/hyperion.ng";
    license = licenses.mit;
    maintainers = with maintainers; [ algram ];
    platforms = platforms.unix;
  };
}
