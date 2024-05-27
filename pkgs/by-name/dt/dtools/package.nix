{ lib
, stdenv
, fetchFromGitHub
, ldc
, curl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtools";
  version = "2.108.0";

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YEBUgJPG/+WN4MnQUNAVftZM0ULxZZzpHoOozXua46U=";
    name = "dtools";
  };

  patches = [
    # Disable failing tests
    ./disabled-tests.diff
    # Fix LDC arm64 build
    ./fix-ldc-arm64.diff
  ];

  nativeBuildInputs = [ ldc ];
  buildInputs = [ curl ];

  makeFlags = [
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
