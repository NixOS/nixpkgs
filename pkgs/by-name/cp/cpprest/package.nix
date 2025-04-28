{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  websocketpp,
  openssl,
  zlib,
  boost177,
}:
stdenv.mkDerivation {
  pname = "cpprest";
  version = "2.10.19";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "cpprestsdk";
    rev = "411a109150b270f23c8c97fa4ec9a0a4a98cdecf";
    sha256 = "09pb16aqs4x6xgsvj6fpwxzqa4px11j5qigcpjsb3hbsbkvsd9nc";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    websocketpp
    boost177
    zlib
  ];

  propagatedBuildInputs = [
    # Headers include openssl/conf.h
    openssl
  ];

  NIX_CFLAGS_COMPILE = "-Wno-format-truncation";

  meta = {
    description = "Library for cloud-based client-server communication in native code using a modern asynchronous C++ API design.";
    homepage = "https://github.com/microsoft/cpprestsdk";
    license = lib.licenses.mit;
    # Should support darwin too but needs some extra poking to build
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
