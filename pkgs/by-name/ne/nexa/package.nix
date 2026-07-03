{
  config,
  lib,
  buildGo125Module,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  unzip,
  stdenv,
  vulkan-loader,
  zlib,

  # Feature flags (all enabled by default, set slim = true to disable all optional deps)
  slim ? false,
  enableCuda ? !slim && stdenv.hostPlatform.isLinux && config.cudaSupport,
  enableVulkan ? !slim && stdenv.hostPlatform.isLinux,

  # Optional dependencies
  cudaPackages,
  gfortran,
  pcre2,
  darwinMinVersionHook,
  openssl,
  fftw,
  lame,
  mpg123,
  llvmPackages,
}:

let
  bridgeVersion = "1.0.45-rc1";

  bridge = fetchurl {
    url =
      let
        platformDir =
          {
            x86_64-linux = "linux_x86_64";
            aarch64-linux = "linux_arm64";
            aarch64-darwin = "macos_arm64";
          }
          .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      in
      "https://nexa-model-hub-bucket.s3.us-west-1.amazonaws.com/public/nexasdk/v${bridgeVersion}/${platformDir}/nexasdk-bridge.zip";
    hash =
      {
        x86_64-linux = "sha256-bvULCeGXNd8Alu7V32M5Me23Rh6of6L7hdPYrkOlxB0=";
        aarch64-linux = "sha256-KaHNmq776FtE4tF8jROV43QIyUNaYz/V1kkgMwwjcBo=";
        aarch64-darwin = "sha256-QVh5HutaB/BfCYRgwXdtMVWtDcYzfL9N9qW2GhcK2aY=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };
in
buildGo125Module (finalAttrs: {
  pname = "nexa";
  version = "0.2.73";

  src = fetchFromGitHub {
    owner = "NexaAI";
    repo = "nexa-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JioUguVO2z37BYxkXBlDEswJIh80bpOONG6EVNlq5OA=";
  };

  modRoot = "runner";

  vendorHash = "sha256-ovDlt8WpZB7VcNJ8Oy0YDRsreR15fMT7rIHPpd4JVGY=";

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      stdenv.cc.cc.lib
      zlib
      pcre2
      gfortran.cc.lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "12.0")
    ]
    ++ lib.optionals enableVulkan [
      vulkan-loader
    ]
    ++ lib.optionals enableCuda [
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
    ];

  # libcuda.so.1 is provided by the NVIDIA driver at runtime
  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux (
    [
      "libcuda.so.1"
    ]
    ++ lib.optionals (!enableCuda) [
      "libcudart.so.12"
      "libcublas.so.12"
      "libcublasLt.so.12"
    ]
    ++ [
      "libavformat.so.58"
      "libavfilter.so.7"
      "libavcodec.so.58"
      "libavutil.so.56"
      "libswresample.so.3"
    ]
    ++ lib.optionals (!enableVulkan) [
      "libvulkan.so.1"
    ]
  );

  subPackages = [
    "cmd/nexa-cli"
    "cmd/nexa-launcher"
  ];

  preBuild = ''
    unzip ${bridge} -d build
  '';

  env.CGO_ENABLED = "1";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  tags = [
    "sonic"
    "avx"
  ];

  doCheck = false;

  doInstallCheck = true;
  # Can't use versionCheckHook because nexa requires $HOME to be set
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$TMPDIR
    output="$($out/bin/nexa version 2>&1 || true)"
    echo "$output"
    echo "$output" | grep -q "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  postInstall = ''
    mv $out/bin/nexa-launcher $out/bin/nexa

    # Preserve subdirectory structure — the bridge scans subdirs for plugins
    mkdir -p $out/lib
    cp -R build $out/lib/nexa
    chmod -R u+w $out/lib/nexa
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-rpath $out/lib/nexa $out/bin/nexa-cli
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath $out/lib/nexa $out/bin/nexa-cli

    # Rewrite hardcoded homebrew paths in prebuilt bridge dylibs
    for f in $(find $out/lib/nexa -name '*.dylib'); do
      for ref in $(otool -L "$f" | awk '/\/opt\/homebrew/ {print $1}'); do
        lib_name=$(basename "$ref")
        case "$lib_name" in
          libssl*|libcrypto*)   new_path="${openssl.out}/lib/$lib_name" ;;
          libfftw3.3.dylib)     new_path="${fftw.out}/lib/$lib_name" ;;
          libfftw3f.3.dylib)    new_path="${fftw.out}/lib/$lib_name" ;;
          libmp3lame*)          new_path="${lame.lib}/lib/$lib_name" ;;
          libmpg123*)           new_path="${mpg123.out}/lib/$lib_name" ;;
          libomp*)              new_path="${llvmPackages.openmp}/lib/$lib_name" ;;
          *)
            echo "ERROR: unknown homebrew reference in $f: $ref"
            echo "Add a replacement for $lib_name to the case statement above"
            exit 1
            ;;
        esac
        install_name_tool -change "$ref" "$new_path" "$f"
      done
      # Fix self-referencing install names with homebrew paths
      id=$(otool -D "$f" | tail -1)
      if [[ "$id" == /opt/homebrew/* ]]; then
        install_name_tool -id "$f" "$f"
      fi
    done

    # Final verification: fail if any homebrew references remain
    remaining=$(find $out/lib/nexa -name '*.dylib' -exec otool -L {} + | grep /opt/homebrew/ || true)
    if [[ -n "$remaining" ]]; then
      echo "ERROR: homebrew references remain after patching:"
      echo "$remaining"
      exit 1
    fi
  '';

  meta = {
    description = "Nexa AI SDK CLI for model management, inference, and server operations";
    homepage = "https://github.com/NexaAI/nexa-sdk";
    changelog = "https://github.com/NexaAI/nexa-sdk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "nexa";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
