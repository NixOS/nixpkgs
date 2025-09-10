{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-auth,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-event-stream,
  aws-c-http,
  aws-c-io,
  aws-c-mqtt,
  aws-c-s3,
  aws-checksums,
  cmake,
  s2n-tls,
  nix,
}:

stdenv.mkDerivation rec {
  pname = "aws-crt-cpp";
  # nixpkgs-update: no auto update
  version = "0.33.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-crt-cpp";
    rev = "v${version}";
    sha256 = "sha256-C8KWe5+CXujD8nN3gLkjaaMld15sat/ohwEKhyWELKI=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "$<INSTALL_INTERFACE:include>" "$<INSTALL_INTERFACE:$dev/include>" \
      --replace-fail '-Werror' ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    aws-c-auth
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-event-stream
    aws-c-http
    aws-c-io
    aws-c-mqtt
    aws-c-s3
    aws-checksums
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postInstall = ''
    # Prevent dependency cycle.
    moveToOutput lib/aws-crt-cpp/cmake "$dev"
  '';

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C++ wrapper around the aws-c-* libraries";
    homepage = "https://github.com/awslabs/aws-crt-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
