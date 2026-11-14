{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  nifticlib,
  zlib,
  ctestCheckHook,
}:

stdenv.mkDerivation {
  pname = "gifticlib";
  version = "0-unstable-2020-07-07";

  src = fetchFromGitHub {
    owner = "NIFTI-Imaging";
    repo = "gifti_clib";
    rev = "5eae81ba1e87ef3553df3b6ba585f12dc81a0030";
    hash = "sha256-KfDfqRS3cf+MSceh/k504KPMSftf35mplTmC+gxYij0=";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_NIFTI=ON"
    "-DDOWNLOAD_TEST_DATA=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    expat
    nifticlib
    zlib
  ];

  # without the test data, this is only a few basic tests
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [ ctestCheckHook ];
  checkFlags = [
    "-LE"
    "NEEDS_DATA"
  ];

  meta = {
    homepage = "https://www.nitrc.org/projects/gifti";
    description = "Medical imaging geometry format C API";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.publicDomain;
  };
}
