{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  zlib,
  libuv,
  # External poll is required for e.g. mosquitto, but discouraged by the maintainer.
  withExternalPoll ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwebsockets";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8UY0UHdzlc4DXB5YNc5dUj2u5BfLXK5JJfCrncP4UzM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    openssl
    zlib
    libuv
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DLWS_WITH_PLUGINS=ON"
    "-DLWS_WITH_IPV6=ON"
    "-DLWS_WITH_SOCKS5=ON"
    # Prevents dependency on GnuTLS
    "-DLWS_WITH_HTTP3=OFF"
    "-DDISABLE_WERROR=ON"
    "-DLWS_BUILD_HASH=no_hash"
    "-DLWS_WITHOUT_TESTAPPS=OFF"
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-DLWS_WITHOUT_TESTAPPS=ON"
  ++ lib.optional withExternalPoll "-DLWS_WITH_EXTERNAL_POLL=ON"
  ++ (
    if stdenv.hostPlatform.isStatic then
      [ "-DLWS_WITH_SHARED=OFF" ]
    else
      [
        "-DLWS_WITH_STATIC=OFF"
        "-DLWS_LINK_TESTAPPS_DYNAMIC=ON"
      ]
  );

  postInstall = ''
    # The package builds a few test programs that are not usually necessary.
    # Move those to the dev output.
    moveToOutput "bin/libwebsockets-test-*" "$dev"
    moveToOutput "share/libwebsockets-test-*" "$dev"
  '';

  # $out/share/libwebsockets-test-server/plugins/libprotocol_*.so refers to crtbeginS.o
  disallowedReferences = [ stdenv.cc.cc ];

  meta = {
    description = "Light, portable C library for websockets";
    longDescription = ''
      Libwebsockets is a lightweight pure C library built to
      use minimal CPU and memory resources, and provide fast
      throughput in both directions.
    '';
    homepage = "https://libwebsockets.org/";
    # Relicensed from LGPLv2.1+ to MIT with 4.0. Licensing situation
    # is tricky, see https://github.com/warmcat/libwebsockets/blob/main/LICENSE
    license = with lib.licenses; [
      mit
      publicDomain
      bsd3
      asl20
    ];
    maintainers = with lib.maintainers; [ mindavi ];
    platforms = lib.platforms.all;
  };
})
