{
  lib,
  llvmPackages,
  fetchgit,
  cmake,
  ninja,
  pkg-config,
  bison,
  gawk,
  gperf,
  python3,
  ruby,
  perl,
  icu,
  libxml2,
  zlib,
  darwin,
  cctools,
  sqlite,
  readline,
  libedit,
  bun-unwrapped,
}:

let
  sources = lib.importJSON ../sources.json;
  inherit (llvmPackages.stdenv.hostPlatform)
    isAarch64
    isDarwin
    isLinux
    isx86_64
    ;
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "bun-webkit";
  inherit (sources.webkit) version;

  # update.py updates the revision and hash, not sparseCheckout. Add paths when
  # a new WebKit revision needs them.
  src = fetchgit {
    name = "bun-webkit-source";
    url = "https://github.com/oven-sh/WebKit.git";
    inherit (sources.webkit) rev hash sparseCheckout;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bison
    gawk
    gperf
    python3
    ruby
    perl
  ]
  ++ lib.optionals isDarwin [
    cctools
    darwin.bootstrap_cmds
  ];

  buildInputs = [
    libxml2
    zlib
  ]
  ++ lib.optional isLinux icu
  ++ lib.optionals isDarwin [
    darwin.ICU
    sqlite
    readline
    libedit
  ];

  # Review these settings against Bun's local WebKit build in webkit.ts.
  cmakeBuildType = "RelWithDebInfo";
  cmakeFlags = [
    (lib.cmakeFeature "PORT" "JSCOnly")
    (lib.cmakeBool "ENABLE_STATIC_JSC" true)
    (lib.cmakeBool "USE_THIN_ARCHIVES" false)
    (lib.cmakeBool "ENABLE_FTL_JIT" true)
    (lib.cmakeBool "ENABLE_TOOLS" false)
    (lib.cmakeBool "ENABLE_API_TESTS" false)
    (lib.cmakeBool "USE_BUN_JSC_ADDITIONS" true)
    (lib.cmakeBool "USE_BUN_EVENT_LOOP" true)
    (lib.cmakeBool "USE_MIMALLOC" true)
    (lib.cmakeBool "USE_EXTERNAL_MIMALLOC" true)
    (lib.cmakeBool "ENABLE_BUN_SKIP_FAILING_ASSERTIONS" true)
    (lib.cmakeBool "ALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS" true)
    (lib.cmakeBool "ENABLE_REMOTE_INSPECTOR" true)
    (lib.cmakeBool "ENABLE_MEDIA_SOURCE" false)
    (lib.cmakeBool "ENABLE_MEDIA_STREAM" false)
    (lib.cmakeBool "ENABLE_WEB_RTC" false)
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" false)
  ]
  ++ lib.optionals isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_SYSROOT" "")
    (lib.cmakeFeature "CMAKE_Swift_COMPILER" "${llvmPackages.stdenv.cc}/bin/clang")
    (lib.cmakeFeature "GPERF_EXECUTABLE" (lib.getExe gperf))
    (lib.cmakeFeature "Mig_EXECUTABLE" (lib.getExe' darwin.bootstrap_cmds "mig"))
  ];

  # Match computeCpuTargetFlags() in webkit.ts. Bun and JavaScriptCore need the
  # same CPU baseline.
  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
    [
      "-gz=zlib"
      "-ffile-prefix-map=${finalAttrs.src}/Source=vendor/WebKit/Source"
      "-fno-pic"
      "-fno-pie"
      "-no-pie"
    ]
    ++ lib.optional isx86_64 "-march=nehalem"
    ++ lib.optional (isAarch64 && isDarwin) "-mcpu=apple-m1"
    ++ lib.optionals (isAarch64 && isLinux) [
      "-march=armv8-a+crc"
      "-mtune=ampere1"
    ]
  );

  ninjaFlags = [ "jsc" ];

  # webkit.ts provides() reads these libraries and generated headers directly.
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp lib/lib*.a "$out/lib/"
    install -Dm644 cmakeconfig.h "$out/cmakeconfig.h"

    for directory in \
      JavaScriptCore/Headers \
      JavaScriptCore/PrivateHeaders \
      WTF/Headers \
      bmalloc/Headers; do
      mkdir -p "$out/$directory"
      cp -rL "$directory"/. "$out/$directory/"
    done

    # Make Bun's prebuilt dependency rule accept this already-built tree.
    printf 'nix\n' > "$out/.identity"

    runHook postInstall
  '';

  meta = {
    description = "Build of WebKit with extra patches used by Bun";
    homepage = "https://github.com/oven-sh/WebKit";
    license = lib.licenses.lgpl21Only;
    inherit (bun-unwrapped.meta) maintainers platforms;
  };
})
