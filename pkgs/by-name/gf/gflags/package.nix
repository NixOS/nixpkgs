{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gflags";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    tag = "v${finalAttrs.version}";
    hash = "sha256-haLm7T0ZrXLuGMYEszhKkBJEMV9SUjos5X7vXlHd0uU=";
  };

  nativeBuildInputs = [ cmake ];

  # This isn't used by the build and breaks the CMake build on case-insensitive filesystems (e.g., on Darwin)
  preConfigure = "rm BUILD";

  cmakeFlags = [
    "-DGFLAGS_BUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}"
    "-DGFLAGS_BUILD_STATIC_LIBS=ON"
  ];

  doCheck = false;

  meta = {
    description = "C++ library that implements commandline flags processing";
    mainProgram = "gflags_completions.sh";
    longDescription = ''
      The gflags package contains a C++ library that implements commandline flags processing.
      As such it's a replacement for getopt().
      It was owned by Google. google-gflags project has been renamed to gflags and maintained by new community.
    '';
    homepage = "https://gflags.github.io/gflags/";
    changelog = "https://github.com/gflags/gflags/blob/${finalAttrs.src.tag}/ChangeLog.txt";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
