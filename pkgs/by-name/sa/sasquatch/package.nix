{
  lib,
  stdenv,
  fetchFromGitHub,
  lz4,
  lzo,
  which,
  xz,
  zlib,
  zstd,
  bigEndian ? false,
}:

let
  drv = stdenv.mkDerivation (finalAttrs: {
    pname = "sasquatch";
    version = "4.5.1-4";

    src = fetchFromGitHub {
      owner = "onekey-sec";
      repo = "sasquatch";
      rev = "sasquatch-v${finalAttrs.version}";
      hash = "sha256-0itva+j5WMKvueiUaO253UQ1S6W29xgtFvV4i3yvMtU=";
    };

    patches = lib.optional stdenv.hostPlatform.isDarwin ./darwin.patch;

    strictDeps = true;
    nativeBuildInputs = [ which ];
    buildInputs = [
      zlib
      xz
      zstd
      lz4
      lzo
    ];

    preBuild = ''
      cd squashfs-tools
    '';

    installFlags = [
      "INSTALL_DIR=${placeholder "out"}/bin"
      "INSTALL_MANPAGES_DIR=${placeholder "out"}/share/man/man1"
    ];

    makeFlags = [
      "GZIP_SUPPORT=1"
      "LZ4_SUPPORT=1"
      "LZMA_SUPPORT=1"
      "LZO_SUPPORT=1"
      "XZ_SUPPORT=1"
      "ZSTD_SUPPORT=1"
      "AR:=$(AR)"
    ];

    env.NIX_CFLAGS_COMPILE = lib.optionalString bigEndian "-DFIX_BE";

    postInstall = lib.optionalString bigEndian ''
      mv $out/bin/sasquatch{,-v4be}
    '';

    meta = {
      homepage = "https://github.com/onekey-sec/sasquatch";
      description = "Set of patches to the standard unsquashfs utility (part of squashfs-tools) that attempts to add support for as many hacked-up vendor-specific SquashFS implementations as possible";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ vlaci ];
      platforms = lib.platforms.unix;
      mainProgram = if bigEndian then "sasquatch-v4be" else "sasquatch";
    };
  });
in
drv
