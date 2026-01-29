{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # for passthru.tests
  intel-compute-runtime,
  intel-media-driver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-gmmlib";
  version = "22.9.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    tag = "intel-gmmlib-${finalAttrs.version}";
    hash = "sha256-hgVdUTbPLEKVZpg+73kxpeMQ5gOjBHeRAJgTYds9lYQ=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit intel-compute-runtime intel-media-driver;
  };

  meta = {
    homepage = "https://github.com/intel/gmmlib";
    license = lib.licenses.mit;
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
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
