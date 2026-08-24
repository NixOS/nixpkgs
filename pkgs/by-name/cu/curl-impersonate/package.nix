{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  buildPackages,
  cmake,
  ninja,
  pkg-config,
  autoconf,
  automake,
  libtool,
  unzip,
  fixDarwinDylibNames,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "curl-impersonate";
  version = "2.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lexiforest";
    repo = "curl-impersonate";
    tag = "v${version}";
    hash = "sha256-gN4TD+WxQM2eJofHsOHA/JpH6bQ8CI3VUTPL8NuySn4=";
  };

  separateDebugInfo = true;
  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    installShellFiles
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Rewrite the dylib's install name to its absolute store path.
    # Without this it keeps upstream's "@rpath/libcurl-impersonate.4.dylib",
    # and every consumer linking it (e.g. python3Packages.curl-cffi's
    # extension module, and through it yt-dlp) records an @rpath reference
    # with no LC_RPATH set, failing at dlopen with "no LC_RPATH's found".
    fixDarwinDylibNames
  ];

  # Upstream CMake build wants its own specific versions of
  # zlib, zstd, brotli, nghttp2, ngtcp2, nghttp3, boringssl.
  # These come from passthru.deps, instead of buildInputs.

  cmakeFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      "-DCURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # This fork's CMakeLists sets USE_APPLE_IDN=ON expecting curl to use Apple's IDN support.
      # This however results in no IDN at all in the built binary (none listed in -V)? Force to
      # use libidn instead, this needs the -liconv in postPatch below
      "-DUSE_LIBIDN2=ON"
    ];

  patches = [
    ./darwin-libidn2-linker-flags.patch
  ];

  postPatch =
    let
      localDep = name: "file://${passthru.deps.${name}}";
    in
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'URL "''${ZLIB_URL}"' 'URL "${localDep "zlib-1.3.1.tar.gz"}"' \
        --replace-fail 'URL "''${ZSTD_URL}"' 'URL "${localDep "zstd-1.5.7.tar.gz"}"' \
        --replace-fail 'URL "''${BROTLI_URL}"' 'URL "${localDep "brotli-1.2.0.tar.gz"}"' \
        --replace-fail 'URL "''${BORINGSSL_URL}"' 'URL "${localDep "boringssl-156c7b75ae9b8c3b3f847acf264f17594c3859fb.zip"}"' \
        --replace-fail 'URL "''${NGHTTP2_URL}"' 'URL "${localDep "nghttp2-1.63.0.tar.bz2"}"' \
        --replace-fail 'URL "''${NGTCP2_URL}"' 'URL "${localDep "ngtcp2-1.20.0.tar.bz2"}"' \
        --replace-fail 'URL "''${NGHTTP3_URL}"' 'URL "${localDep "nghttp3-1.15.0.tar.bz2"}"' \
        --replace-fail 'URL "''${CURL_URL}"' 'URL "${localDep "curl-8_21_0.tar.gz"}"'

      substituteInPlace scripts/build-libidn2.sh \
        --replace-fail '[ -f "$archive" ] || curl -L "$libidn2_url" -o "$archive"' \
          '[ -f "$archive" ] || cp ${passthru.deps."libidn2-2.3.7.tar.gz"} "$archive"'
    '';

  preConfigure = ''
    # Prebuild libidn2 (statically, with bundled libunistring) offline,
    # matching `make prepare-libidn2`.
    BUILD_DIR="$PWD/build" ZIG_FLAGS='-target ${stdenv.hostPlatform.config}' ./scripts/build-libidn2.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $dev/include
    install -Dm755 deps/build/curl/src/curl-impersonate $out/bin/curl-impersonate
    cp -P deps/build/curl/lib/libcurl-impersonate.* $out/lib/
    cp -r deps/src/curl/include/curl $dev/include/curl
    install -Dm755 -t $out/bin ../bin/curl_*

    runHook postInstall
  '';

  postInstall = ''
    patchShebangs $out/bin
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    version_output=$($out/bin/curl-impersonate -V)
    echo "$version_output"
    echo "$version_output" | grep -q zlib
    echo "$version_output" | grep -q zstd
    echo "$version_output" | grep -q brotli
    echo "$version_output" | grep -q nghttp2
    echo "$version_output" | grep -q BoringSSL
    echo "$version_output" | grep -q IDN

    runHook postInstallCheck
  '';

  doInstallCheck = true;

  passthru = {
    deps = callPackage ./deps.nix { };

    updateScript = ./update.sh;

    inherit src;
    tests = { inherit (nixosTests) curl-impersonate; };
  };

  meta = {
    changelog = "https://github.com/lexiforest/curl-impersonate/releases/tag/${src.tag}";
    description = "Special build of curl that can impersonate Chrome, Edge, Safari and Firefox";
    homepage = "https://github.com/lexiforest/curl-impersonate";
    license = with lib.licenses; [
      curl
      mit
    ];
    maintainers = with lib.maintainers; [
      ui-1
    ];
    platforms = lib.platforms.unix;
    mainProgram = "curl-impersonate";
  };
}
