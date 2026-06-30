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
  version = "4.5.8";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0pLBxOSKaxboHd9L27RKKqSJ9lVH4wPgKSyXEoJMal4=";
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
    "-DDISABLE_WERROR=ON"
    "-DLWS_BUILD_HASH=no_hash"
    # TODO(Mindavi): figure out why linking has broken for test apps between 4.3.5 and 4.4.1.
    "-DLWS_WITHOUT_TESTAPPS=ON"
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

  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail '=\''${exec_prefix}/''${LWS_INSTALL_LIB_DIR}' '=''${CMAKE_INSTALL_FULL_LIBDIR}' \
      --replace-fail '=\''${prefix}/''${LWS_INSTALL_INCLUDE_DIR}' '=''${CMAKE_INSTALL_FULL_INCLUDEDIR}'
  ''
  # Remove after https://github.com/warmcat/libwebsockets/pull/3567 has been merged or otherwise addressed
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace "cmake/libwebsockets-config.cmake.in" --replace-fail \
      "set(LIBWEBSOCKETS_LIBRARIES websockets websockets_shared)" \
      "set(LIBWEBSOCKETS_LIBRARIES websockets)"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix doubled store path in macOS install_name
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'SET(CMAKE_INSTALL_NAME_DIR "''${CMAKE_INSTALL_PREFIX}/''${LWS_INSTALL_LIB_DIR}")' \
        'SET(CMAKE_INSTALL_NAME_DIR "''${LWS_INSTALL_LIB_DIR}")'
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic "";

  postInstall = ''
    # Fix path that will be incorrect on move to "dev" output.
    substituteInPlace "$out/lib/cmake/libwebsockets/LibwebsocketsTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}" "$out"

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
