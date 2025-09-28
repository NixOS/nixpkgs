{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
  ];

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
  ];

  meta = {
    description = "Embedded C/C++ web server";
    mainProgram = "civetweb";
    homepage = "https://github.com/civetweb/civetweb";
    license = [ lib.licenses.mit ];
  };
})
