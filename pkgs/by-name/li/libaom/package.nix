{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  yasm,
  perl,
  cmake,
  pkg-config,
  python3,
  enableVmaf ? true,
  libvmaf,
  gitUpdater,

  # for passthru.tests
  ffmpeg,
  libavif,
  libheif,
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libaom";
  version = "3.15.0";

  src = fetchzip {
    url = "https://aomedia.googlesource.com/aom/+archive/v${finalAttrs.version}.tar.gz";
    hash = "sha256-TixZQP06TEZPtpHvWVOEagzHtXW9hqXWweO2yimBDG4=";
    stripRoot = false;
  };

  patches = [
    ./outputs.patch
  ];

  nativeBuildInputs = [
    yasm
    perl
    cmake
    pkg-config
    python3
  ];

  propagatedBuildInputs = lib.optional enableVmaf libvmaf;

  env =
    lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
      # This can be removed when we switch to libcxx from llvm 20
      # https://github.com/llvm/llvm-project/pull/122361
      NIX_CFLAGS_COMPILE = "-D_XOPEN_SOURCE=700";
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      # _POSIX_C_SOURCE breaks system headers on Darwin; it's required on musl
      NIX_CFLAGS_COMPILE = "-D_POSIX_C_SOURCE=200112L";
    };

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v${finalAttrs.version}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  # Configuration options:
  # https://aomedia.googlesource.com/aom/+/refs/heads/master/build/cmake/aom_config_defaults.cmake

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_TESTS=OFF"
  ]
  ++ lib.optionals enableVmaf [
    "-DCONFIG_TUNE_VMAF=1"
  ]
  ++ lib.optionals (isCross && !stdenv.hostPlatform.isx86) [
    "-DCMAKE_ASM_COMPILER=${lib.getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    # armv7l-hf-multiplatform does not support NEON
    # see lib/systems/platform.nix
    "-DENABLE_NEON=0"
  ];

  postFixup = ''
    moveToOutput lib/libaom.a "$static"
    substituteInPlace "$dev"/lib/cmake/*/*.cmake \
      --replace-quiet "$out/lib/libaom.a" "$static/lib/libaom.a" \
      --replace-quiet "$"'{_IMPORT_PREFIX}/include' "$dev/include"
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    ln -s $static $out
  '';

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "bin"
    "dev"
    "static"
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://aomedia.googlesource.com/aom";
      rev-prefix = "v";
      ignoredVersions = "(alpha|beta|rc).*";
    };
    tests = {
      inherit libavif libheif;
      ffmpeg = ffmpeg.override { withAom = true; };
    };
  };

  meta = {
    description = "Alliance for Open Media AV1 codec library";
    longDescription = ''
      Libaom is the reference implementation of the AV1 codec from the Alliance
      for Open Media. It contains an AV1 library as well as applications like
      an encoder (aomenc) and a decoder (aomdec).
    '';
    homepage = "https://aomedia.org/av1-features/get-started/";
    changelog = "https://aomedia.googlesource.com/aom/+/refs/tags/v${finalAttrs.version}/CHANGELOG";
    maintainers = with lib.maintainers; [
      dandellion
    ];
    platforms = lib.platforms.all;
    outputsToInstall = [ "bin" ];
    license = lib.licenses.bsd2;
  };
})
