{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "civetweb";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "civetweb";
    repo = "civetweb";
    rev = "v${version}";
    sha256 = "sha256-Qh6BGPk7a01YzCeX42+Og9M+fjXRs7kzNUCyT4mYab4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

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
  ];

  meta = {
    description = "Embedded C/C++ web server";
    mainProgram = "civetweb";
    homepage = "https://github.com/civetweb/civetweb";
    license = [ lib.licenses.mit ];
  };
}
