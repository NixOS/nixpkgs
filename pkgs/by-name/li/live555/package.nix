{ lib
, darwin
, fetchurl
, fetchpatch
, openssl
, stdenv
, vlc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live555";
  version = "2023.11.30";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${finalAttrs.version}.tar.gz"
      "https://src.rrz.uni-hamburg.de/files/src/live555/live.${finalAttrs.version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${finalAttrs.version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-xue+9YtdAM2XkzAY6dU2PZ3n6bvPwlULIHqBqc8wuSU=";
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

  strictDeps = true;

  # Since NIX_CFLAGS_COMPILE does not differentiate C and C++ toolchains, we
  # set CXXFLAGS directly
  env.CXXFLAGS = "-std=c++20";

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
  + lib.optionalString (stdenv.hostPlatform.libc == "glibc"
                        || stdenv.hostPlatform.libc == "musl") ''
    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

  configurePhase = let
    platform = if stdenv.isLinux
               then "linux"
               else if stdenv.isDarwin
               then "macosx-catalina"
               else throw "Unsupported platform: ${stdenv.hostPlatform.system}";
  in ''
    runHook preConfigure

    ./genMakefiles ${platform}

    runHook postConfigure
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

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
