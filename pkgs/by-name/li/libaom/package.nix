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
stdenv.mkDerivation rec {
  pname = "libaom";
  version = "3.10.0";

  src = fetchzip {
    url = "https://aomedia.googlesource.com/aom/+archive/v${version}.tar.gz";
    hash = "sha256-7xtIT8zalh1XJfVKWeC/+jAkhOuFHw6Q0+c2YMtDark=";
    stripRoot = false;
  };

  patches =
    [
      ./outputs.patch
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      # This patch defines `_POSIX_C_SOURCE`, which breaks system headers
      # on Darwin.
      (fetchurl {
        name = "musl.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-libs/libaom/files/libaom-3.4.0-posix-c-source-ftello.patch?id=50c7c4021e347ee549164595280cf8a23c960959";
        hash = "sha256-6+u7GTxZcSNJgN7D+s+XAVwbMnULufkTcQ0s7l+Ydl0=";
      })
    ];

  nativeBuildInputs = [
    yasm
    perl
    cmake
    pkg-config
    python3
  ];

  propagatedBuildInputs = lib.optional enableVmaf libvmaf;

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v${version}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  # Configuration options:
  # https://aomedia.googlesource.com/aom/+/refs/heads/master/build/cmake/aom_config_defaults.cmake

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=ON"
      "-DENABLE_TESTS=OFF"
    ]
    ++ lib.optionals enableVmaf [
      "-DCONFIG_TUNE_VMAF=1"
    ]
    ++ lib.optionals (isCross && !stdenv.hostPlatform.isx86) [
      "-DCMAKE_ASM_COMPILER=${stdenv.cc.targetPrefix}as"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch32 [
      # armv7l-hf-multiplatform does not support NEON
      # see lib/systems/platform.nix
      "-DENABLE_NEON=0"
    ];

  postFixup =
    ''
      moveToOutput lib/libaom.a "$static"
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      ln -s $static $out
    '';

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

  meta = with lib; {
    description = "Alliance for Open Media AV1 codec library";
    longDescription = ''
      Libaom is the reference implementation of the AV1 codec from the Alliance
      for Open Media. It contains an AV1 library as well as applications like
      an encoder (aomenc) and a decoder (aomdec).
    '';
    homepage = "https://aomedia.org/av1-features/get-started/";
    changelog = "https://aomedia.googlesource.com/aom/+/refs/tags/v${version}/CHANGELOG";
    maintainers = with maintainers; [
      primeos
      kiloreux
      dandellion
    ];
    platforms = platforms.all;
    outputsToInstall = [ "bin" ];
    license = licenses.bsd2;
  };
}
