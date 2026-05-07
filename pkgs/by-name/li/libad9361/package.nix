{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libad9361";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libad9361-iio";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "IIO AD9361 library for filter design and handling, multi-chip sync, etc";
    homepage = "http://analogdevicesinc.github.io/libad9361-iio/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
