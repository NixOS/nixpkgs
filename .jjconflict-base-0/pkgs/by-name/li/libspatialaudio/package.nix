{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ krav ];
  };
}
