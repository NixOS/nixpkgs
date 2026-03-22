{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libuv,
  openssl,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "libwebsockets";
  version = "4.3.0-14";

  src = fetchurl {
    url = "https://ardour.org/files/deps/libwebsockets-${version}.tar.gz";
    hash = "sha256-kp3gkOE6NnGfxN8E2tKmZ+/2lJh7wmvdXwHWk3TpBxA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libuv
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DDISABLE_WERROR=ON"
    "-DLWS_BUILD_HASH=no_hash"
    "-DLWS_LINK_TESTAPPS_DYNAMIC=ON"
    "-DLWS_WITH_IPV6=ON"
    "-DLWS_WITH_PLUGINS=ON"
    "-DLWS_WITH_SOCKS5=ON"
    "-DLWS_WITH_STATIC=OFF"
    "-DLWS_WITHOUT_TESTAPPS=ON"
  ];

  meta = {
    description = "Ardour-pinned libwebsockets build";
    homepage = "https://ardour.org/";
    license = with lib.licenses; [
      mit
      publicDomain
      bsd3
      asl20
    ];
    platforms = [ "aarch64-darwin" ];
  };
}
