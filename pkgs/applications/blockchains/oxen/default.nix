{ stdenv, lib, fetchurl, fetchFromGitHub, fetchpatch
, cmake, pkg-config
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
    sha512 = "4c18d784085179c5b1fcb753a93813095a12c8d34970f2e1bfca6499be6c9d67769c71c68b7ca54ff181b20390043170e89733c22f76ff1ea46494814f7095b1";
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
    "-DCMAKE_BUILD_TYPE=Release"
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
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/oxen.x86_64-darwin
  };
}
