{
  bintools,
  callPackage,
  cacert,
  curlMinimal,
  dart,
  fetchurl,
  gn,
  gitMinimal,
  gitSetupHook,
  icu,
  lib,
  pax-utils,
  python312,
  ripgrep,
  runCommand,
  samurai,
  stdenv,
  versionCheckHook,
  writeText,
  zlib,
  pkg-config,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  tools = callPackage ../../../development/compilers/flutter/engine/tools.nix {
    inherit (stdenv) hostPlatform buildPlatform;
  };

  archMap = selectSystem {
    "aarch64-linux" = {
      arch = "arm64";
      outSuffix = "ReleaseARM64";
    };
    "riscv64-linux" = {
      arch = "riscv64";
      outSuffix = "ReleaseRISCV64";
    };
    "x86_64-linux" = {
      arch = "x64";
      outSuffix = "ReleaseX64";
    };
  };

  python3 = (
    python312.withPackages (
      ps: with ps; [
        httplib2
        six
      ]
    )
  );

  src =
    runCommand "dart-source-deps"
      {
        pname = "dart-source-deps";
        inherit (dart) version;

        nativeBuildInputs = [
          cacert
          curlMinimal
          gitMinimal
          pax-utils
          python3
          tools.cipd
        ];

        env = {
          NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
          GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
          DEPOT_TOOLS_UPDATE = "0";
          DEPOT_TOOLS_COLLECT_METRICS = "0";
          PYTHONDONTWRITEBYTECODE = "1";
        };

        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = "sha256-beLMEIyO6JwM3NRXnSTA4LSpIxxC7cRXrv18YXtBh08=";
      }
      ''
        mkdir source
        cd source
        source ${../../../build-support/fetchgit/deterministic-git}
        export -f clean_git
        export -f make_deterministic_repo
        cp ${writeText ".gclient" ''
          solutions = [{
              'name': 'sdk',
              'url': 'https://dart.googlesource.com/sdk.git@${dart.version}',
          }]
          target_cpu = ['x64', 'arm64', 'riscv64']
          target_cpu_only = True
        ''} .gclient
        export PATH=${python3}/bin:$PATH:${tools.depot_tools}
        python3 ${tools.depot_tools}/gclient.py sync --no-history --nohooks
        rm --recursive --force sdk/buildtools/sysroot
        rm --recursive --force sdk/buildtools/*/clang
        rm --force .gclient .gclient_entries .gclient_previous_sync_commits .last_sync_hashes
        rm --recursive --force .cipd .cipd_cache
        find . -name ".git" -type d -prune -exec rm --recursive --force {} +
        find . -name ".git*" -exec rm --recursive --force {} +
        find . \( \
            -name "ChangeLog*" -o \
            -name ".build-id" -o \
            -name ".svn" -o \
            -name "*~" -o \
            -name "#*#" \
        \) -exec rm --recursive --force {} +
        for elf in $(scanelf --recursive --all --format "%F" sdk | sort); do
            rm --force "$elf"
        done
        find . -name "__pycache__" -type d -exec rm --recursive --force {} +
        find . -name "*.pyc" -delete
        cp --recursive sdk $out
      '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dart-source";
  inherit (dart) version;
  inherit src;

  nativeBuildInputs = [
    gitMinimal
    gitSetupHook
    python312
    ripgrep
    pkg-config
  ];

  buildInputs = [
    icu
    zlib
  ];

  patches = [
    ./gcc13.patch
    ./unbundle.patch
    ./unbundle-icu.patch
    ./zlib-not-found.patch
    ./fix-toolchain-prefix.patch
    ./custom-flags.patch
  ];

  postPatch = ''
    patchShebangs runtime/tools/
    sed --in-place 's/ldflags = pkgresult\[4\]/ldflags = []/' build/config/linux/pkg_config.gni
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/chromium/chromium/631a813125b886a52274653144019fd1681a0e97/build/config/linux/pkg-config.py";
        hash = "sha256-9coRpgCewlkFXSGrMVkudaZUll0IFc9jDRBP+2PloOI=";
      }
    } build/config/linux/pkg-config.py
    rm --recursive --force tools/sdks/dart-sdk
    ln --symbolic ${dart} tools/sdks/dart-sdk
    ln --symbolic --force ${lib.getExe gn} buildtools/gn
    mkdir --parents buildtools/ninja
    ln --symbolic --force ${lib.getExe samurai} buildtools/ninja/ninja
    python3 tools/generate_package_config.py
    python3 tools/generate_sdk_version_file.py
    echo "" > tools/bots/dartdoc_footer.html
    rm third_party/devtools/web/devtools_analytics.js
    JOBS_COUNT=''${NIX_BUILD_CORES:-2}
    rg --no-ignore -l 'google-analytics\.com' . \
      | rg -v "\.map\$" \
      | xargs --no-run-if-empty -t -n 1 -P "$JOBS_COUNT" \
        sed --in-place --regexp-extended 's|([^/]+\.)?google-analytics\.com|0\.0\.0\.0|g'
    rg --no-ignore -l 'UA-[0-9]+-[0-9]+' . \
      | xargs --no-run-if-empty -t -n 1 -P "$JOBS_COUNT" \
        sed --in-place --regexp-extended 's|UA-[0-9]+-[0-9]+|UA-2137-0|g'
    for _lib in icu zlib; do
        find . -type f -path "*third_party/$_lib/*" \
            \! -path "*third_party/$_lib/chromium/*" \
            \! -path "*third_party/$_lib/google/*" \
            \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
            -delete
    done
    python3 build/linux/unbundle/replace_gn_files.py --system-libraries icu zlib
    git init
    git add .
    git commit --message="stub" --quiet
  '';

  buildPhase = ''
    runHook preBuild

    python3 ./tools/build.py \
      --no-clang \
      --mode=release \
      --arch=${archMap.arch} \
      --gn-args="dart_embed_icu_data=false dart_snapshot_kind=\"app-jit\" dart_sysroot=\"\"" \
      --no-verify-sdk-hash \
      create_sdk runtime

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/libexec $out/bin
    rm --recursive --force out/${archMap.outSuffix}/dart-sdk/LICENSE
    rm --recursive --force out/${archMap.outSuffix}/dart-sdk/README
    rm --recursive --force out/${archMap.outSuffix}/dart-sdk/revision
    cp --recursive out/${archMap.outSuffix}/dart-sdk $out/libexec/dart
    ln --symbolic $out/libexec/dart/bin/dart $out/bin/dart
    ln --symbolic $out/libexec/dart/bin/dartaotruntime $out/bin/dartaotruntime
    ln --symbolic $out/libexec/dart/include $out/include
    find $out/libexec/dart/bin -executable -type f -exec patchelf --set-interpreter ${bintools.dynamicLinker} {} \;

    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = dart.passthru // {
    updateScript = null;
    tests = {
      testCreate = dart.passthru.tests.testCreate.overrideAttrs (_: {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      });
      testCompile = dart.passthru.tests.testCompile.overrideAttrs (_: {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      });
    };
  };

  meta = dart.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ ];
  };
})
