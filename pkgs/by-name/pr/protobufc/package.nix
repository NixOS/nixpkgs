{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  protobuf_33,
  zlib,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protobuf-c";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bpxk2o5rYLFkx532A3PYyhh2MwVH2Dqf3p/bnNpQV7s=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    protobuf_33
    zlib
  ];

  # The upstream macro is vendored from a very old autoconf archive:
  # https://github.com/protobuf-c/protobuf-c/commit/42612b4ba4b11d48b76e3643fa6d42f617e661b6
  # and the build system appears to arbitrarily require C++17 specifically:
  # https://github.com/protobuf-c/protobuf-c/blob/4719fdd7760624388c2c5b9d6759eb6a47490626/configure.ac#L72
  # However, the default standard version used by GCC continues to increase
  # (e.g. C++20 for GCC 16), and so protobuf-c's dependencies do as well. In
  # particular, abseil-cpp has headers that protobuf-c includes and are
  # sensitive to the standard version. While we could override the standard
  # version used by these dependents, it is simpler to drop the requirement and
  # allow the compiler default standard to be used.
  postPatch = ''
    substituteInPlace configure.ac --replace-fail \
      "AX_CXX_COMPILE_STDCXX(17, noext, mandatory)" ""
  '';

  env.PROTOC = lib.getExe buildPackages.protobuf_33;

  meta = {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
