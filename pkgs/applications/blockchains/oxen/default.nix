{ stdenv, lib, fetchurl, fetchFromGitHub, cmake, pkg-config
, boost, openssl, unbound
, pcsclite, readline, libsodium, hidapi
, rapidjson
, curl, sqlite
, trezorSupport ? true
, libusb1
, protobuf
, python3
}:

stdenv.mkDerivation rec {
  pname = "oxen";
  version = "9.1.3";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = "oxen-core";
    rev = "v${version}";
    sha256 = "11g3wqn0syk47yfcsdql5737kpad8skwdxhifn2yaz9zy8n3xqqb";
    fetchSubmodules = true;
  };

  # Required for static linking, the only supported install path
  lbzmqsrc = fetchurl {
    url = "https://github.com/zeromq/libzmq/releases/download/v4.3.3/zeromq-4.3.3.tar.gz";
    hash = "sha512-TBjXhAhRecWx/LdTqTgTCVoSyNNJcPLhv8pkmb5snWd2nHHGi3ylT/GBsgOQBDFw6Jczwi92/x6kZJSBT3CVsQ==";
  };

  postPatch = ''
    # remove vendored libraries
    rm -r external/rapidjson
    sed -i s,/lib/,/lib64/, external/loki-mq/cmake/local-libzmq//LocalLibzmq.cmake
  '';

  postInstall = ''
    rm -R $out/lib $out/include
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost openssl unbound
    pcsclite readline
    libsodium hidapi rapidjson
    protobuf curl sqlite
  ] ++ lib.optionals trezorSupport [ libusb1 protobuf python3 ];

  cmakeFlags = [
    # "-DUSE_DEVICE_TREZOR=ON"
    # "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
    # It build with shared libs but doesn't install them. Fail.
    # "-DBUILD_SHARED_LIBS=ON"
    "-DLIBZMQ_TARBALL_URL=${lbzmqsrc}"
  ] ++ lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  meta = with lib; {
    description = "Private cryptocurrency based on Monero";
    homepage = "https://oxen.io/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.viric ];
    # Fails to build on gcc-10 due to boost being built with gcc-12.
    broken = true;
  };
}
