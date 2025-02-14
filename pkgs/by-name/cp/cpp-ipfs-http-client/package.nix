{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  cmake,
  nlohmann_json,
}:

stdenv.mkDerivation {
  pname = "cpp-ipfs-http-client";
  version = "unstable-2022-01-30";

  src = fetchFromGitHub {
    owner = "vasild";
    repo = "cpp-ipfs-http-client";
    rev = "3cdfa7fc6326e49fc81b3c7ca43ce83bdccef6d9";
    sha256 = "sha256-/oyafnk4SbrvoCh90wkZXNBjknMKA6EEUoEGo/amLUo=";
  };

  patches = [ ./unvendor-nlohmann-json.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '# Fetch "JSON for Modern C++"' "include_directories(${nlohmann_json}/include)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl ];
  propagatedBuildInputs = [ nlohmann_json ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=range-loop-construct"
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

  meta = with lib; {
    description = "IPFS C++ API client library";
    homepage = "https://github.com/vasild/cpp-ipfs-http-client";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
