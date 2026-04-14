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
  version = "0-unstable-2023-06-04";

  src = fetchFromGitHub {
    owner = "vasild";
    repo = "cpp-ipfs-http-client";
    rev = "29a103af79ad62ef42180f54f6cd2128b4128836";
    hash = "sha256-B57W4OqNU0M4yYxbHIZb2TyHfMaihCOD1KdvPrm6xLE=";
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

  meta = {
    description = "IPFS C++ API client library";
    homepage = "https://github.com/vasild/cpp-ipfs-http-client";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
}
