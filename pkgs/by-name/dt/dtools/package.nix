{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, ldc
, curl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtools";
  version = "2.106.1";

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y8jSwd6tldCnq3yEuO/xUYrSV+lp7tBPMiheMA06f0M=";
    name = "dtools";
  };

  patches = [
    # Disable failing tests
    ./disabled-tests.diff
    # Fix LDC arm64 build
    (fetchpatch {
      # part of https://github.com/dlang/tools/pull/441
      url = "https://github.com/dlang/tools/commit/6c6a042d1b08e3ec1790bd07a7f69424625ee866.patch";
      hash = "sha256-x6EclTYN1Y5FG57KLhbBK0BZicSYcZoWO7MTVcP4T18=";
    })
  ];

  nativeBuildInputs = [ ldc ];
  buildInputs = [ curl ];

  makeFlags = [
    "-fposix.mak"
    "CC=${stdenv.cc}/bin/cc"
    "DMD=${ldc.out}/bin/ldmd2"
    "INSTALL_DIR=$(out)"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test_rdmd";

  meta = with lib; {
    description = "Ancillary tools for the D programming language";
    homepage = "https://github.com/dlang/tools";
    license = licenses.boost;
    maintainers = with maintainers; [ jtbx ];
    platforms = platforms.unix;
  };
})
