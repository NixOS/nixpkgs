{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # for passthru.tests
  intel-compute-runtime,
  intel-media-driver,
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "22.5.5";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    rev = "intel-gmmlib-${version}";
    hash = "sha256-F8e9FzEn6A7U8lyso5YDhWaB+S5M45HRvj95AyteovQ=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit intel-compute-runtime intel-media-driver;
  };

  meta = with lib; {
    homepage = "https://github.com/intel/gmmlib";
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    longDescription = ''
      The Intel(R) Graphics Memory Management Library provides device specific
      and buffer management for the Intel(R) Graphics Compute Runtime for
      OpenCL(TM) and the Intel(R) Media Driver for VAAPI.
    '';
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
