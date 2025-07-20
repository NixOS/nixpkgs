{
  buildPackages,
  cctools,
  fetchpatch,
  fetchurl,
  lib,
  live555,
  openssl,
  runCommand,
  stdenv,
  writeScript,

  # tests
  vlc,
}:
let
  isStatic = stdenv.hostPlatform.isStatic;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "live555";
  version = "2024.09.20";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${finalAttrs.version}.tar.gz"
      "https://src.rrz.uni-hamburg.de/files/src/live555/live.${finalAttrs.version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${finalAttrs.version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-TrUneCGaJJxC+GgL1ZZ/ZcONeqDH05Bp44/3lkCs9tg=";
  };

  patches = [
    (fetchpatch {
      name = "0000-cflags-when-darwin.patch";
      url = "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1";
      hash = "sha256-IDSdByBu/EBLsUTBe538rWsDwH61RJfAEhvT68Nb9rU=";
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  buildInputs = [
    openssl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "C_COMPILER=$(CC)"
    "CPLUSPLUS_COMPILER=$(CXX)"
    "LINK=$(CXX) -o "
    "LIBRARY_LINK=${if isStatic then "$(AR) cr " else "$(CC) -o "}"
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
  +
    lib.optionalString
      (lib.elem stdenv.hostPlatform.libc [
        "glibc"
        "musl"
      ])
      ''
        substituteInPlace liveMedia/include/Locale.hh \
          --replace '<xlocale.h>' '<locale.h>'
      '';

  configurePhase =
    let
      platform =
        if stdenv.hostPlatform.isLinux then
          if isStatic then "linux" else "linux-with-shared-libraries"
        else if stdenv.hostPlatform.isDarwin then
          "macosx-catalina"
        else
          throw "Unsupported platform: ${stdenv.hostPlatform.system}";
    in
    ''
      runHook preConfigure

      ./genMakefiles ${platform}

      runHook postConfigure
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    if ! ($out/bin/openRTSP || :) 2>&1 | grep -q "Usage: "; then
      echo "Executing example program failed" >&2
      exit 1
    else
      echo "Example program executed successfully"
    fi
  '';

  passthru.tests =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    {
      # The installCheck phase above cannot be ran in cross-compilation scenarios,
      # therefore the passthru test
      run-test-prog = runCommand "live555-run-test-prog" { } ''
        if ! (${emulator} ${live555}/bin/openRTSP || :) 2>&1 | grep -q "Usage: "; then
          echo "Executing example program failed" >&2
          exit 1
        else
          echo "Example program executed successfully"
          touch $out
        fi
      '';

      inherit vlc;
    };

  passthru.updateScript = writeScript "update-live555" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts

    # Expect the text in format of '2025.05.24:'
    new_version="$(curl -s http://www.live555.com/liveMedia/public/changelog.txt |
      head -n1 | tr -d ':')"
    update-source-version live555 "$new_version"
  '';

  meta = {
    homepage = "http://www.live555.com/liveMedia/";
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    changelog = "http://www.live555.com/liveMedia/public/changelog.txt";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
