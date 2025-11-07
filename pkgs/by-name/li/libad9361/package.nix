{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiio,
}:

stdenv.mkDerivation rec {
  pname = "libad9361";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libad9361-iio";
    rev = "v${version}";
    hash = "sha256-9e66qSrKpczatZY9lPAzi/6f7lHChnl2+Pih53oa28Y=";
  };

  patches = [
    # Update CMake minimum required version for CMake 4 compatibility
    # https://github.com/analogdevicesinc/libad9361-iio/pull/134
    ./cmake-3.10.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libiio ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix iio include path on darwin to match linux
    for i in test/*.c; do
      substituteInPlace $i \
        --replace 'iio/iio.h' 'iio.h'
    done
  '';

  meta = with lib; {
    description = "IIO AD9361 library for filter design and handling, multi-chip sync, etc";
    homepage = "http://analogdevicesinc.github.io/libad9361-iio/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
