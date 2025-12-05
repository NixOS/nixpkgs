{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  openssl,
  zlib,
  aws-crt-cpp,
  nix,
  arrow-cpp,
  aws-sdk-cpp,
  # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? [ "*" ],
  # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true,
  # Builds in 2+h with 2 cores, and ~10m with a big-parallel builder.
  requiredSystemFeatures ? [ "big-parallel" ],
}:

let
  host_os =
    if stdenv.hostPlatform.isDarwin then
      "APPLE"
    else if stdenv.hostPlatform.isAndroid then
      "ANDROID"
    else if stdenv.hostPlatform.isWindows then
      "WINDOWS"
    else if stdenv.hostPlatform.isLinux then
      "LINUX"
    else
      throw "Unknown host OS";
in

stdenv.mkDerivation rec {
  pname = "aws-sdk-cpp";
  # nixpkgs-update: no auto update
  version = "1.11.647";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    tag = version;
    hash = "sha256-RJKR0xw3HTNItaLGyYCjibmfK3UBDA4hfAZzQ0xYg9U=";
  };

  postPatch = ''
    # Append the dev output to path hints in finding Aws.h to avoid
    # having to pass `AWS_CORE_HEADER_FILE` explicitly to cmake configure
    # when using find_package(AWSSDK CONFIG)
    substituteInPlace cmake/AWSSDKConfig.cmake \
      --replace 'C:/AWSSDK/''${AWSSDK_INSTALL_INCLUDEDIR}/aws/core' \
        'C:/AWSSDK/''${AWSSDK_INSTALL_INCLUDEDIR}/aws/core"
            "${placeholder "dev"}/include/aws/core'

    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    substituteInPlace cmake/compiler_settings.cmake \
      --replace '"-Werror"' ' '

    # Flaky on Hydra
    rm tests/aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    rm tests/aws-cpp-sdk-core-tests/aws/client/AWSClientTest.cpp
    rm tests/aws-cpp-sdk-core-tests/aws/client/AwsConfigTest.cpp
    # Includes aws-c-auth private headers, so only works with submodule build
    rm tests/aws-cpp-sdk-core-tests/aws/auth/AWSAuthSignerTest.cpp
    # TestRandomURLMultiThreaded fails
    rm tests/aws-cpp-sdk-core-tests/http/HttpClientTest.cpp
  ''
  + lib.optionalString stdenv.hostPlatform.isi686 ''
    # EPSILON is exceeded
    rm tests/aws-cpp-sdk-core-tests/aws/client/AdaptiveRetryStrategyTest.cpp
  '';

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    curl
  ];

  buildInputs = [
    curl
    openssl
    zlib
  ];

  # propagation is needed for Security.framework to be available when linking
  propagatedBuildInputs = [ aws-crt-cpp ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
  ]
  ++ lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DENABLE_TESTING=OFF"
    "-DCURL_HAS_H2=1"
    "-DCURL_HAS_TLS_PROXY=1"
    "-DTARGET_ARCH=${host_os}"
  ]
  ++ lib.optional (apis != [ "*" ]) "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  env.NIX_CFLAGS_COMPILE = toString [
    # openssl 3 generates several deprecation warnings
    "-Wno-error=deprecated-declarations"
  ];

  postFixupHooks = [
    # This bodge is necessary so that the file that the generated -config.cmake file
    # points to an existing directory.
    "mkdir -p $out/include"
  ];

  __darwinAllowLocalNetworking = true;

  inherit requiredSystemFeatures;

  passthru = {
    tests = {
      inherit nix arrow-cpp;
      cmake-find-package = stdenv.mkDerivation {
        pname = "aws-sdk-cpp-cmake-find-package-test";
        version = "0";
        dontUnpack = true;
        nativeBuildInputs = [ cmake ];
        buildInputs = [ aws-sdk-cpp ];
        buildCommand = ''
          cat > CMakeLists.txt <<'EOF'
          find_package(AWSSDK)
          EOF

          # Intentionally not using 'cmakeConfigurePhase' to test that find_package works without it.
          mkdir build && cd build
          if output=$(cmake -Wno-dev .. 2>&1); then
            if grep -Fw -- "Found AWS" - <<< "$output"; then
              touch "$out"
            else
              echo "'Found AWS' not found in the cmake output!" >&2
              echo "The output was:" >&2
              echo "$output" >&2
              exit 1
            fi
          else
            echo -n "'cmake -Wno-dev ..'" >&2
            echo " returned a non-zero exit code." >&2
            echo "$output" >&2
            exit 1
          fi
        '';
      };
    };
  };

  meta = with lib; {
    description = "C++ interface for Amazon Web Services";
    homepage = "https://github.com/aws/aws-sdk-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ ];
    # building ec2 runs out of memory: cc1plus: out of memory allocating 33554372 bytes after a total of 74424320 bytes
    broken = stdenv.buildPlatform.is32bit && ((builtins.elem "ec2" apis) || (builtins.elem "*" apis));
  };
}
