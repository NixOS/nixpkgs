{
  lib,
  stdenv,
  cctools,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  gn,
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
  libName = "libperfetto${if isStatic then ".a" else extensions.sharedLibrary}";

  buildInputs = [
    protobuf
    re2
    sqlite
    zlib
    zstd
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
    }) buildInputs
  );
  systemModules = toString (lib.attrNames systemLibs);

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
  version = "58.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "perfetto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-73aE+qoHOkdD2Br3NmUE48BM6uE6uIBdug0+ZR2nn94=";
  };

  patches = [
    # TODO: remove once included in a next release
    (fetchpatch2 {
      url = "https://github.com/google/perfetto/commit/e698e3903870da0317511334ee21d3ae830ecd66.patch?full_index=1";
      hash = "sha256-L3/xAz1dc3KDZLs7nt7F945ZuvexyWlA9x0YqRNjdIo=";
    })
    (fetchpatch2 {
      url = "https://github.com/google/perfetto/commit/5739344741e4b881952a2786f67355eefe0a2c8d.patch?full_index=1";
      hash = "sha256-AplecRNDDLGpbYC6zg2Ie0LrX+0MBxodTC72SP6SSl8=";
    })
  ];
  # Upstream includes its own tooling to download its deps, we have to disable it to make it use the ones from the PATH.
  postPatch = ''
    echo '#!/usr/bin/env python3' > tools/install-build-deps
    substituteInPlace tools/run_buildtools_binary.py \
      --replace-fail "and sys_name == 'freebsd'" ""

    substituteInPlace gn/standalone/toolchain/BUILD.gn \
      --replace-fail 'default_output_extension = ".so"' 'default_output_extension = "${extensions.sharedLibrary}"'
  '';

  nativeBuildInputs = [
    gn
    ninja
    pkg-config
    protobuf
    python3
    validatePkgConfig
  ]
  ++ lib.optional isDarwin cctools.libtool;

  inherit buildInputs;

  gnFlags = toGnFlags (
    commonGnFlags
    // (lib.optionalAttrs (!isStatic) {
      extra_ldflags = "-Wl,-rpath,${placeholder "out"}/lib";
    })
  );

  ninjaFlags = [
    "tracebox"
    "traced"
    "traced_probes"
    "perfetto"
  ];

  dontUseNinjaInstall = true;
  installPhase = ''
    runHook preInstall

    install -Dt $out/bin perfetto traced traced_probes tracebox
    ${lib.optionalString (!isStatic) "install -Dt $out/lib ${libName}"}

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
        propagatedBuildInputs = buildInputs;

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
    mainProgram = "perfetto";
    platforms = lib.platforms.unix;
  };
})
