{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "curlpp";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "jpbarrette";
    repo = "curlpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M/PYA/CW6sc7JO67b7QulogIpguZGCz5JF01mK2lHqw=";
  };

  patches = [
    # https://github.com/jpbarrette/curlpp/pull/171
    ./curl_8_10_build_failure.patch
  ];

  buildInputs = [ curl ];
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://www.curlpp.org/";
    description = "C++ wrapper around libcURL";
    mainProgram = "curlpp-config";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
