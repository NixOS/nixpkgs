{ lib
, stdenv
, fetchFromGitHub
, cmake
, buildTests ? false
, buildFuzzer ? false
, buildExamples ? false
}:

stdenv.mkDerivation rec {
  pname = "cppdap";
  version = "1.58.0-a";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cppdap";
    rev = "dap-${version}";
    sha256 = "sha256-c7U8ItFmsh+PiFF/JK4gWTBhZn46CoOXI7Rl+50Uc3c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = []
    ++ lib.optionals buildTests [ "-DCPPDAP_BUILD_TESTS=ON" ]
    ++ lib.optionals buildFuzzer [ "-DCPPDAP_BUILD_FUZZER=ON" ]
    ++ lib.optionals buildExamples [ "-DCPPDAP_BUILD_EXAMPLES=ON" ];

  # Temporary patch to satisfy this check "https://github.com/google/cppdap/blob/252b56807b532533ea7362a4d949758dcb481d2b/CMakeLists.txt#L63"
  prePatch = ''
    mkdir -p $TMP/source/third_party/googletest/.git
  '';

  postInstall = ''
    mkdir -p $out/bin
  '' + lib.optionalString buildTests ''
    install -Dm755 "$TMP/source/build/cppdap-unittests" "$out/bin/cppdap-unittests"
  '' + lib.optionalString buildFuzzer ''
    install -Dm755 "$TMP/source/build/cppdap-fuzzer" "$out/bin/cppdap-fuzzer"
  '' + lib.optionalString buildExamples ''
    mkdir -p $out/bin/examples
    install -Dm755 "$TMP/source/build/hello_debugger" "$out/bin/examples/hello_debugger"
    install -Dm755 "$TMP/source/build/simple_net_client_server" "$out/bin/examples/simple_net_client_server"
  '';
  
  meta = {
    homepage = "https://github.com/google/cppdap";
    description = "C++ library for the Debug Adapter Protocol";
    license = lib.licenses.asl20;
    # See "https://github.com/Kitware/CMake/blob/5e79703f93be8374efd8e9dfe570d03a6c48e4ab/CMakeLists.txt#L139-L143"
    platforms = lib.flatten (with lib.platforms; [ linux darwin freebsd netbsd openbsd windows cygwin ]);
    maintainers = with lib.maintainers; [ nsidiropoulos ];
  };
}