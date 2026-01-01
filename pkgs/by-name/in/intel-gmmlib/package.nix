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
<<<<<<< HEAD
  version = "22.9.0";
=======
  version = "22.8.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "gmmlib";
    tag = "intel-gmmlib-${version}";
<<<<<<< HEAD
    hash = "sha256-hgVdUTbPLEKVZpg+73kxpeMQ5gOjBHeRAJgTYds9lYQ=";
=======
    hash = "sha256-dn8I3cuApy+RUWeKDVzU0sr3fUjHoDFHdGasFTAufec=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    inherit intel-compute-runtime intel-media-driver;
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/intel/gmmlib";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/intel/gmmlib";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
