{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  openssl,
  zlib,
  libuv,
  # External poll is required for e.g. mosquitto, but discouraged by the maintainer.
  withExternalPoll ? false,
}:

stdenv.mkDerivation rec {
  pname = "libwebsockets";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${version}";
    hash = "sha256-KOAhIVn4G5u0A1TE75Xv7iYO3/i8foqWYecH0kJHdBM=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2025-11677.patch";
      url = "https://libwebsockets.org/git/libwebsockets/patch?id=2f082ec31261f556969160143ba94875d783971a";
      hash = "sha256-FeiZAbr1kpt+YNjhi2gfG2A6nXKiSssMFRmlALaneu4=";
    })
    (fetchpatch {
      name = "CVE-2025-11678.patch";
      url = "https://libwebsockets.org/git/libwebsockets/patch?id=2bb9598562b37c942ba5b04bcde3f7fdf66a9d3a";
      hash = "sha256-1uQUkoMbK+3E/QYMIBLlBZypwHBIrWBtm+KIW07WRj8=";
    })
  ];

  # Updating to 4.4.1 would bring some errors, and the patch doesn't apply cleanly
  # https://github.com/warmcat/libwebsockets/commit/47efb8c1c2371fa309f85a32984e99b2cc1d614a
  postPatch = ''
    for f in $(find . -name CMakeLists.txt); do
      sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' -i "$f"
    done
  '';

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

  meta = with lib; {
    description = "Light, portable C library for websockets";
    longDescription = ''
      Libwebsockets is a lightweight pure C library built to
      use minimal CPU and memory resources, and provide fast
      throughput in both directions.
    '';
    homepage = "https://libwebsockets.org/";
    # Relicensed from LGPLv2.1+ to MIT with 4.0. Licensing situation
    # is tricky, see https://github.com/warmcat/libwebsockets/blob/main/LICENSE
    license = with licenses; [
      mit
      publicDomain
      bsd3
      asl20
    ];
    maintainers = with maintainers; [ mindavi ];
    platforms = platforms.all;
  };
}
