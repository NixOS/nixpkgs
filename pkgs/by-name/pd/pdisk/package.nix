{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdisk";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "pdisk";
    tag = "pdisk-${lib.versions.minor finalAttrs.version}";
    hash = "sha256-+gBgnk/1juEHE0nXaz7laUaH7sxrX5SzsLGr0PHsdHs=";
  };

  patches = [
    # Fix makefile for Unix
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/makefile.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9
    ./makefile.patch
    # Fix lseek usage in file_media.c
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/file_media.c.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9
    ./file_media.c.patch
    # Fix open_partition_map call in cvt_pt.c
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/cvt_pt.c.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9
    ./cvt_pt.c.patch
    # Replace removed sys_nerr and sys_errlist with strerror
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/linux_strerror.patch?h=pdisk&id=d0c930ea8bcac008bbd0ade1811133a625caea54
    ./linux_strerror.patch

    # Fix missing includes on Linux
    ./cmdline.patch
  ];

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail 'cc' '${stdenv.cc.targetPrefix}cc' \
      --replace-fail 'CFLAGS = ' 'CFLAGS = -std=c99 '
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace makefile \
      --replace-fail '-lbsd' '-framework CoreFoundation -framework IOKit'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libbsd
  ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    for exe in pdisk cvt_pt; do
      install -Dm755 -t $out/bin $exe
    done

    installManPage pdisk.8
    install -Dm644 pdisk.html $out/share/doc/pdisk/pdisk.html

    runHook postInstall
  '';

  meta = {
    description = "Low-level Apple partition table editor for Linux, OSS Apple version";
    homepage = "https://github.com/apple-oss-distributions/pdisk";
    license = with lib.licenses; [
      hpnd # original license statements seems to match this (in files that are shared with mac-fdisk)
      apple-psl10 # new files
    ];
    mainProgram = "pdisk";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
  };
})
