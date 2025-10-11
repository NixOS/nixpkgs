{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "gflags";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "v${version}";
    sha256 = "147i3md3nxkjlrccqg4mq1kyzc7yrhvqv5902iibc7znkvzdvlp0";
  };

  patches = [
    # Fix the build with CMake 4.
    (fetchpatch {
      name = "gflags-fix-cmake-4.patch";
      url = "https://github.com/gflags/gflags/commit/70c01a642f08734b7bddc9687884844ca117e080.patch";
      hash = "sha256-TYdroBbF27Wvvm/rOahBEvhezuKCcxbtgh/ZhpA5ESo=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  # This isn't used by the build and breaks the CMake build on case-insensitive filesystems (e.g., on Darwin)
  preConfigure = "rm BUILD";

  cmakeFlags = [
    "-DGFLAGS_BUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}"
    "-DGFLAGS_BUILD_STATIC_LIBS=ON"
  ];

  doCheck = false;

  meta = with lib; {
    description = "C++ library that implements commandline flags processing";
    mainProgram = "gflags_completions.sh";
    longDescription = ''
      The gflags package contains a C++ library that implements commandline flags processing.
      As such it's a replacement for getopt().
      It was owned by Google. google-gflags project has been renamed to gflags and maintained by new community.
    '';
    homepage = "https://gflags.github.io/gflags/";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
