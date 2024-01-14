{ lib
, darwin
, fetchurl
, openssl
, stdenv
, vlc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live555";
  version = "2023.05.10";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${finalAttrs.version}.tar.gz"
      "https://src.rrz.uni-hamburg.de/files/src/live555/live.${finalAttrs.version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${finalAttrs.version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-6ph9x4UYELkkJVIE9r25ycc5NOYbPcgAy9LRZebvGFY=";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    darwin.cctools
  ];

  buildInputs = [
    openssl
  ];

  strictDeps = true;

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
