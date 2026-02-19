{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  cmake,
  pkg-config,
  libx11,
  libxcb,
  libxkbcommon,
  xinput,
  libxt,
  libxtst,
  libxi,
  libxinerama,
  libxext,
  libxdmcp,
  libxau,
  libxkbfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libuiohook";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "kwhat";
    repo = "libuiohook";
    rev = finalAttrs.version;
    sha256 = "1qlz55fp4i9dd8sdwmy1m8i4i1jy1s09cpmlxzrgf7v34w72ncm7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libx11
    libxcb
    libxkbcommon
    xinput
    libxau
    libxdmcp
    libxi
    libxinerama
    libxt
    libxtst
    libxext
    libxkbfile
  ];

  outputs = [
    "out"
    "test"
  ];

  # We build the tests, but they're only installed when using the "test" output.
  # This will produce a "uiohook_tests" binary which can be run to test the
  # functionality of the library on the current system.
  # Running the test binary requires a running X11 session.
  cmakeFlags = [
    "-DENABLE_TEST:BOOL=ON"
  ];

  postInstall = ''
    mkdir -p $test/share
    cp ./uiohook_tests $test/share
  '';

  meta = {
    description = "C library to provide global keyboard and mouse hooks from userland";
    homepage = "https://github.com/kwhat/libuiohook";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ anoa ];
  };

  passthru.tests.libuiohook = nixosTests.libuiohook;
})
