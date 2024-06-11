{
  lib,
  darwin,
  fetchpatch,
  fetchurl,
  openssl,
  stdenv,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live555";
  version = "2024.05.15";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${finalAttrs.version}.tar.gz"
      "https://src.rrz.uni-hamburg.de/files/src/live555/live.${finalAttrs.version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${finalAttrs.version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-Mgkf5XiFBEEDTTx+YlV12wE4zpmPPqaUPv9KcEK38D0=";
  };

  patches = [
    (fetchpatch {
      name = "cflags-when-darwin.patch";
      url = "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1";
      hash = "sha256-IDSdByBu/EBLsUTBe538rWsDwH61RJfAEhvT68Nb9rU=";
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];

  buildInputs = [
    openssl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "C_COMPILER=$(CC)"
    "CPLUSPLUS_COMPILER=$(CXX)"
    "LIBRARY_LINK=$(AR) cr "
    "LINK=$(CXX) -o "
  ];

  # Since NIX_CFLAGS_COMPILE affects both C and C++ toolchains, we set CXXFLAGS
  # directly
  env.CXXFLAGS = "-std=c++20";

  strictDeps = true;

  enableParallelBuilding = true;

  # required for whitespaces in makeFlags
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace config.macosx-catalina \
      --replace '/usr/lib/libssl.46.dylib' "${lib.getLib openssl}/lib/libssl.dylib" \
      --replace '/usr/lib/libcrypto.44.dylib' "${lib.getLib openssl}/lib/libcrypto.dylib"
    sed -i -e 's|/bin/rm|rm|g' genMakefiles
    sed -i \
      -e 's/$(INCLUDES) -I. -O2 -DSOCKLEN_T/$(INCLUDES) -I. -O2 -I. -fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T/g' \
      config.linux
  ''
  # condition from icu/base.nix
  + lib.optionalString (lib.elem stdenv.hostPlatform.libc [ "glibc" "musl" ]) ''
    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

  configurePhase = let
    platform =
      if stdenv.isLinux then
        "linux"
      else if stdenv.isDarwin then
        "macosx-catalina"
      else
        throw "Unsupported platform: ${stdenv.hostPlatform.system}";
  in ''
    runHook preConfigure

    ./genMakefiles ${platform}

    runHook postConfigure
  '';

  passthru.tests = {
    # Downstream dependency
    inherit vlc;
  };

  meta = {
    homepage = "http://www.live555.com/liveMedia/";
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    changelog = "http://www.live555.com/liveMedia/public/changelog.txt";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
