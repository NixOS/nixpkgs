{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  makeWrapper,
  opencv,
  libusb,
  boost,
  libGL,
  glew,
  glfw3,
}:

stdenv.mkDerivation {
  name = "openeb";

  src = fetchFromGitHub {
    owner = "prophesee-ai";
    repo = "openeb";
    rev = "b3160f0421b9ef08917a27cc2c24cc46705ddcb4";
    sha256 = "sha256-BTCLkdtUG+ztxT6zJFjejB++Sn85R8QcKn2H39k3Qcs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    makeWrapper
  ];

  buildInputs = [
    opencv
    libusb
    boost
    libGL
    glew
    glfw3
  ];

  cmakeFlags = [ "-DCOMPILE_PYTHON3_BINDINGS=OFF" ];

  postInstall = ''
    for binary in $out/bin/metavision*; do
      wrapProgram $binary \
        --set LD_LIBRARY_PATH ${libGL}/lib
    done
  '';

  meta = with lib; {
    description = "Open source SDK to create applications leveraging event-based vision hardware equipment";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.asl20;
    homepage = "https://www.prophesee.ai/metavision-sdk-pro/";
  };
}
