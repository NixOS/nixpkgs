{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
  versionCheckHook,

  withZlib ? true,
  withUnixSockets ? true,
  withWebSockets ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "civetweb";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "civetweb";
    repo = "civetweb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eXb5f2jhtfxDORG+JniSy17kzB7A4vM0UnUQAfKTquU=";
  };

  patches = [
    ./fix-pkg-config-files.patch
    (fetchpatch {
      name = "CVE-2025-55763.patch";
      url = "https://github.com/civetweb/civetweb/commit/76e222bcb77ba8452e5da4e82ae6cecd499c25e0.patch";
      hash = "sha256-gv2FR53SxmRCCTRjj17RhIjoHkgOz5ENs9oHmcfFmw8=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-I";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optional withZlib zlib;

  # The existence of the "build" script causes `mkdir -p build` to fail:
  #   mkdir: cannot create directory 'build': File exists
  preConfigure = ''
    rm build
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCIVETWEB_ENABLE_CXX=ON"
    "-DCIVETWEB_ENABLE_IPV6=ON"

    # The civetweb unit tests rely on downloading their fork of libcheck.
    "-DCIVETWEB_BUILD_TESTING=OFF"

    # The default stack size in civetweb is 102400 (see the CMakeLists [1]).
    # This can lead to stack overflows even in basic usage;
    # Setting this value to 0 lets the OS choose the stack size instead, which results in a more suitable value.
    #
    # [1] https://github.com/civetweb/civetweb/blob/cafd5f8fae3b859b7f8c29feb03ea075c7221497/CMakeLists.txt#L56
    "-DCIVETWEB_THREAD_STACK_SIZE=0"

    # Workaround CMake 4 compat
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")

    # Support for listening for HTTP requests on a Unix domain socket.
    "-DCMAKE_C_FLAGS=-DUSE_X_DOM_SOCKET"

    (lib.cmakeBool "CIVETWEB_ENABLE_WEBSOCKETS" withWebSockets)

    (lib.cmakeBool "CIVETWEB_ENABLE_ZLIB" withZlib)
  ]

  # Support for listening for HTTP requests on a Unix domain socket.
  ++ lib.optional withUnixSockets "-DCMAKE_C_FLAGS=-DUSE_X_DOM_SOCKET";
  # NOTE Once 1.17 is released, we can use a CMake flag:
  # (lib.cmakeBool "CIVETWEB_ENABLE_X_DOM_SOCKET" withUnixSockets)

  meta = {
    description = "Embedded C/C++ web server";
    mainProgram = "civetweb";
    homepage = "https://github.com/civetweb/civetweb";
    maintainers = with lib.maintainers; [ jlesquembre ];
    license = [ lib.licenses.mit ];
  };
})
