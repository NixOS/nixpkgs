{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "curlpp";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "jpbarrette";
    repo = "curlpp";
    rev = "v${version}";
    sha256 = "1b0ylnnrhdax4kwjq64r1fk0i24n5ss6zfzf4hxwgslny01xiwrk";
  };

  patches = [
    # https://github.com/jpbarrette/curlpp/pull/171
    ./curl_8_10_build_failure.patch
  ];

  buildInputs = [ curl ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://www.curlpp.org/";
    description = "C++ wrapper around libcURL";
    mainProgram = "curlpp-config";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
