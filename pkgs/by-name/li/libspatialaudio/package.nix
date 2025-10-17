{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libmysofa,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libspatialaudio";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = "libspatialaudio";
    rev = version;
    hash = "sha256-sPnQPD41AceXM4uGqWXMYhuQv0TUkA6TZP8ChxUFIoI=";
  };

  # Fix the build with CMake 4.
  #
  # See: <https://github.com/videolabs/libspatialaudio/commit/cec3eeac0984cfd8c1d09fef0dd511c6ccf2a175>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.1)' \
        'cmake_minimum_required(VERSION 3.5)'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libmysofa
    zlib
  ];

  postFixup = ''
    substituteInPlace "''${!outputDev}/lib/pkgconfig/spatialaudio.pc" \
      --replace '-L${lib.getDev libmysofa}' '-L${lib.getLib libmysofa}'
  '';

  meta = with lib; {
    description = "Ambisonic encoding / decoding and binauralization library in C++";
    homepage = "https://github.com/videolabs/libspatialaudio";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ krav ];
  };
}
