{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_13,
  cmake,
  coreutils,
  darwinMinVersionHook,
  libxml2,
  lto ? true,
  makeWrapper,
  openssl,
  pcre2,
  pony-corral,
  python3,
  # Not really used for anything real, just at build time.
  git,
  replaceVars,
  which,
  z3,
  cctools,
  procps,
}:

stdenv.mkDerivation (rec {
  pname = "ponyc";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    hash = "sha256-4gDv8UWTk0RWVNC4PU70YKSK9fIMbWBsQbHboVls2BA=";
    fetchSubmodules = true;
  };

  benchmarkRev = "1.9.1";
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v${benchmarkRev}";
    hash = "sha256-5xDg1duixLoWIuy59WT0r5ZBAvTR6RPP7YrhBYkMxc8=";
  };

  googletestRev = "1.15.2";
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${googletestRev}";
    hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
  };

  nativeBuildInputs =
    [
      cmake
      makeWrapper
      which
      python3
      git
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Keep in sync with `PONY_OSX_PLATFORM`.
      apple-sdk_13
      (darwinMinVersionHook "13.0")
      cctools.libtool
    ];

  buildInputs = [
    libxml2
    z3
  ];

  patches =
    [
      # Sandbox disallows network access, so disabling problematic networking tests
      ./disable-networking-tests.patch
      ./disable-process-tests.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (replaceVars ./fix-darwin-build.patch {
        apple-sdk = apple-sdk_13;
      })
    ];

  postUnpack = ''
    mkdir -p $NIX_BUILD_TOP/deps
    tar -C "$benchmark" -cf $NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar .
    tar -C "$googletest" -cf $NIX_BUILD_TOP/deps/googletest-$googletestRev.tar .
  '';

  dontConfigure = true;

  postPatch = ''
    substituteInPlace packages/process/_test.pony \
        --replace-fail '"/bin/' '"${coreutils}/bin/' \
        --replace-fail '=/bin' "${coreutils}/bin"
    substituteInPlace src/libponyc/pkg/package.c \
        --replace-fail "/usr/local/lib" "" \
        --replace-fail "/opt/local/lib" ""

    # Replace downloads with local copies.
    substituteInPlace lib/CMakeLists.txt \
        --replace-fail "https://github.com/google/benchmark/archive/v$benchmarkRev.tar.gz" "$NIX_BUILD_TOP/deps/benchmark-$benchmarkRev.tar" \
        --replace-fail "https://github.com/google/googletest/archive/refs/tags/v$googletestRev.tar.gz" "$NIX_BUILD_TOP/deps/googletest-$googletestRev.tar"
  '';

  preBuild =
    ''
      extraFlags=(build_flags=-j$NIX_BUILD_CORES)
    ''
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      # See this relnote about building on Raspbian:
      # https://github.com/ponylang/ponyc/blob/0.46.0/.release-notes/0.45.2.md
      extraFlags+=(pic_flag=-fPIC)
    ''
    + ''
      make libs "''${extraFlags[@]}"
      make configure "''${extraFlags[@]}"
    '';

  makeFlags = [
    "PONYC_VERSION=${version}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin ([ "bits=64" ] ++ lib.optional (!lto) "lto=no");

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=redundant-move"
    "-Wno-error=implicit-fallthrough"
  ];

  doCheck = true;

  nativeCheckInputs = [ procps ];

  installPhase =
    ''
      makeArgs=(config=release prefix=$out)
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeArgs+=(bits=64)
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && !lto) ''
      makeArgs+=(lto=no)
    ''
    + ''
      make "''${makeArgs[@]}" install
      wrapProgram $out/bin/ponyc \
        --prefix PATH ":" "${stdenv.cc}/bin" \
        --set-default CC "$CC" \
        --prefix PONYPATH : "${
          lib.makeLibraryPath [
            pcre2
            openssl
            (placeholder "out")
          ]
        }"
    '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  passthru.tests.pony-corral = pony-corral;

  meta = with lib; {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = "https://www.ponylang.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      kamilchm
      patternspandemic
      redvers
      numinit
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
