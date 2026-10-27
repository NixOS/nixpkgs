{
  lib,
  stdenv,
  buildPackages,
  cctools,
  cmake,
  expat,
  fetchFromGitHub,
  fetchpatch2,
  gn,
  linenoise,
  musl-fts,
  ninja,
  nix-update-script,
  pkg-config,
  protobuf,
  python3,
  re2,
  sqlite,
  zlib,
  zstd,
  testers,
  validatePkgConfig,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) isStatic isDarwin extensions;
  isCross = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  libName = "libperfetto${if isStatic then ".a" else extensions.sharedLibrary}";

  # Required for both the SDK and tools output:
  sdkPropagatedBuildInputs = [
    protobuf
    re2
    zlib
    zstd
  ];
  # Required for tools output only:
  toolsInputs = [
    expat
    linenoise
    sqlite
  ];

  # pkg-config module name -> perfetto_use_system_* GN arg suffix
  systemLibs = builtins.listToAttrs (
    builtins.map (drv: {
      name = "${
        if builtins.hasAttr "pkgConfigModules" drv.meta then
          (builtins.head drv.meta.pkgConfigModules)
        else
          drv.pname
      }";
      value = drv.pname;
    }) sdkPropagatedBuildInputs
  );
  systemModules = toString (lib.attrNames systemLibs);

  executablesToInstall = [
    "perfetto"
    "traced_probes"
    "traced"
  ];
  toolsToInstall = [
    "trace_processor_shell"
    "tracebox"
    "traceconv"
  ];

  # Serialize Nix values into GN values, cf.
  # https://gn.googlesource.com/gn/+/main/docs/language.md
  toGnValue =
    value:
    if lib.isBool value then
      lib.boolToString value
    else if lib.isInt value then
      toString value
    else if lib.isString value then
      ''"${lib.escape [ "\"" "$" "\\" ] value}"''
    else
      throw "Unsupported type for GN value: ${lib.generators.toPretty { } value}";
  toGnFlags = lib.mapAttrsToList (name: value: "${name}=${toGnValue value}");

  commonGnFlags = {
    extra_cxxflags = "-std=c++20";
    is_debug = false;
    is_system_compiler = true;
    is_clang = stdenv.cc.isClang;
    monolithic_binaries = isStatic;
    perfetto_use_pkgconfig = true;
    use_custom_libcxx = false;
  }
  // lib.concatMapAttrs (_: gnName: { "perfetto_use_system_${gnName}" = true; }) systemLibs;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "perfetto";
  version = "59.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "perfetto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-411TMDlo9nDbr4RHO772zDJMxHW+cqjw+58RsMplbY8=";
  };

  outputs = [
    "out"
    "tools"
  ];

  patches = [ ];

  # Upstream includes its own tooling to download its deps, we have to disable it to make it use the ones from the PATH.
  postPatch = ''
    echo '#!/usr/bin/env python3' > tools/install-build-deps
    substituteInPlace tools/run_buildtools_binary.py \
      --replace-fail "and sys_name == 'freebsd'" ""

    substituteInPlace gn/standalone/toolchain/BUILD.gn \
      --replace-fail 'default_output_extension = ".so"' 'default_output_extension = "${
        extensions.sharedLibrary or ".a"
      }"'
  '';

  nativeBuildInputs = [
    gn
    ninja
    pkg-config
    protobuf
    python3
    validatePkgConfig
  ]
  ++ lib.optionals isCross (sdkPropagatedBuildInputs ++ toolsInputs)
  ++ lib.optional isDarwin cctools.libtool;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
  ];

  buildInputs =
    sdkPropagatedBuildInputs ++ toolsInputs ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  env = lib.optionalAttrs stdenv.hostPlatform.isMusl {
    NIX_LDFLAGS = "-lfts";
  };

  gnFlags = toGnFlags (
    commonGnFlags
    // (builtins.listToAttrs (
      builtins.map (drv: {
        name = "perfetto_use_system_${drv.pname}";
        value = true;
      }) toolsInputs
    ))
    // {
      enable_perfetto_etm_importer = false;
      enable_perfetto_llvm_demangle = false;
      enable_perfetto_trace_processor_percentile = false;
    }
    // (lib.optionalAttrs (!isStatic) {
      extra_ldflags = "-Wl,-rpath,${placeholder "out"}/lib";
    })
    // (lib.optionalAttrs isCross (
      let
        prefix = stdenv.cc.targetPrefix;
      in
      {
        target_os = if isDarwin then "mac" else "linux";
        target_cpu =
          {
            aarch64 = "arm64";
            armv7l = "arm";
            i686 = "x86";
            powerpc64le = "ppc64";
            s390x = "s390x";
            riscv64 = "riscv64";
            x86_64 = "x64";
          }
          .${stdenv.hostPlatform.parsed.cpu.name};
        target_triplet = stdenv.hostPlatform.config;
        cc = "cc";
        cxx = "c++";
        ar = "ar";
        target_cc = "${prefix}cc";
        target_cxx = "${prefix}c++";
        target_ar = "${prefix}ar";
        target_strip = "${prefix}strip";
        pkg_config = "${prefix}pkg-config";
      }
    ))
  );

  ninjaFlags = executablesToInstall ++ toolsToInstall;

  dontUseNinjaInstall = true;
  installPhase = ''
    runHook preInstall

    install -Dt $out/bin ${builtins.toString executablesToInstall}
    install -Dt $tools/bin ${builtins.toString toolsToInstall}
    ${lib.optionalString (!isStatic) "install -Dt $out/lib ${libName}"}

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $tools/bin/trace_processor_shell \
      -Q "select percentile(x, 50), median(x) from (select 1 x union all select 3)" /dev/null \
    | grep -F '2.0'

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };

    sdk = (
      stdenv.mkDerivation {
        pname = "perfetto-sdk";
        inherit (finalAttrs)
          src
          version
          patches
          postPatch
          nativeBuildInputs
          ;
        propagatedBuildInputs = sdkPropagatedBuildInputs;

        __structuredAttrs = true;
        strictDeps = true;
        outputs = [
          "out"
          "dev"
        ];

        dontUseGnConfigure = true;
        configurePhase = ''
          runHook preConfigure

          python3 tools/gen_amalgamated --quiet --system_buildtools --sdk cpp --output sdk/perfetto \
            --gn_args ${
              lib.escapeShellArg (
                toString (
                  toGnFlags (
                    commonGnFlags
                    // {
                      enable_perfetto_ipc = true;
                      enable_perfetto_pcre2 = false;
                      enable_perfetto_re2 = true;
                      enable_perfetto_zlib = true;
                      enable_perfetto_zstd = true;
                      is_perfetto_build_generator = true;
                      is_perfetto_embedder = true;
                      perfetto_amalgamated_sdk = true;
                      perfetto_enable_git_rev_version_header = true;
                    }
                  )
                )
              )
            }

          runHook postConfigure
        '';

        dontUseNinjaBuild = true;
        buildPhase = ''
          runHook preBuild

          $CXX $CXXFLAGS -std=c++17 -fPIC -O2 -DNDEBUG $($PKG_CONFIG --cflags ${systemModules}) -c sdk/perfetto.cc -o perfetto.o
          ${
            if isStatic then
              "$AR rcs"
            else
              "$CXX $CXXFLAGS $LDFLAGS $($PKG_CONFIG --libs ${systemModules}) ${
                if isDarwin then "-dynamiclib -install_name $out/lib/" else "-shared -lpthread -Wl,-soname,"
              }${libName} -o"
          } ${libName} perfetto.o

          runHook postBuild
        '';

        dontUseNinjaInstall = true;
        installPhase = ''
          runHook preInstall

          install -Dm${if isStatic then "644" else "755"} ${libName} -t $out/lib
          install -Dm644 sdk/perfetto.h -t $out/include

          mkdir -p $out/lib/pkgconfig
          cat -> $out/lib/pkgconfig/perfetto.pc << EOF
          prefix=$out
          exec_prefix=\''${prefix}
          libdir=\''${exec_prefix}/lib
          includedir=\''${prefix}/include

          Name: perfetto
          Description: Perfetto tracing SDK (amalgamated C++ distribution)
          Version: ${finalAttrs.version}
          Cflags: -I\''${includedir}
          Libs: -L\''${libdir} -lperfetto
          Requires.private: ${systemModules}
          EOF

          runHook postInstall
        '';

        passthru = {
          inherit (finalAttrs.passthru) updateScript tests;
        };

        meta = {
          inherit (finalAttrs.meta)
            homepage
            changelog
            license
            maintainers
            platforms
            ;
          description = "Perfetto tracing SDK (amalgamated C++ distribution)";
          pkgConfigModules = [ "perfetto" ];
        };
      }
    );

    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.sdk;
      };

      examples = (
        stdenv.mkDerivation {
          pname = "perfetto-sdk-examples";
          inherit (finalAttrs) src version;

          sourceRoot = "${finalAttrs.src.name}/examples/sdk";

          __structuredAttrs = true;
          strictDeps = true;

          postPatch = ''
            substituteInPlace CMakeLists.txt --replace-fail "$(
              printf '\n%s\n%s\n' \
                'include_directories(../../sdk)' \
                'add_library(perfetto STATIC ../../sdk/perfetto.cc)'
            )" "$(
              printf '\n%s\n%s\n%s\n' \
                'find_package(PkgConfig REQUIRED)' \
                'pkg_check_modules(PERFETTO REQUIRED IMPORTED_TARGET perfetto)' \
                'add_library(perfetto ALIAS PkgConfig::PERFETTO)'
            )"
          '';

          nativeBuildInputs = [
            cmake
            pkg-config
          ];
          buildInputs = [
            finalAttrs.finalPackage.sdk
          ];

          # The CMakeLists.txt file does not define an install target.
          installPhase = ''
            runHook preInstall

            find . -maxdepth 1 -type f -executable -exec install -Dt $out/bin {} +

            runHook postInstall
          '';
          doInstallCheck = true;
          nativeInstallCheckInputs = [ finalAttrs.finalPackage ];
          installCheckPhase = ''
            runHook preInstallCheck

            find $out/bin -maxdepth 1 -type f -executable -not -name example_system_wide -print0 |
            while LC_ALL=C IFS= read -rd "" bin; do
              echo "Running $bin"
              "$bin"
            done

            export PERFETTO_PRODUCER_SOCK_NAME=$TMPDIR/producer.sock
            export PERFETTO_CONSUMER_SOCK_NAME=$TMPDIR/consumer.sock

            traced & tracedPid=$!
            until [[ -e $PERFETTO_PRODUCER_SOCK_NAME && -e $PERFETTO_CONSUMER_SOCK_NAME ]]; do sleep 0.2; done

            timeout 60 $out/bin/example_system_wide & examplePid=$!

            # wait until the example has connected and registered track_event
            for _ in $(seq 100); do
              if perfetto --query | grep -q example_system_wide; then break; fi
              sleep 0.2
            done
            perfetto --query | grep -q example_system_wide  # fail loudly instead of hanging

            perfetto -c /dev/stdin --txt -o $TMPDIR/trace <<'EOF'
            buffers: { size_kb: 4096 }
            data_sources: { config { name: "track_event" } }
            duration_ms: 2000
            EOF

            wait $examplePid
            kill $tracedPid
            [ -s $TMPDIR/trace ]

            runHook postInstallCheck
          '';
        }
      );
    };
  };

  meta = {
    description = "Client-side tracing, profiling, and analysis for complex software systems";
    homepage = "https://perfetto.dev/";
    changelog = "https://github.com/google/perfetto/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aduh95 ];
    mainProgram = lib.head executablesToInstall;
    platforms = lib.platforms.unix;
  };
})
