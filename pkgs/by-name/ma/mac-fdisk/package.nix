{
  stdenv,
  lib,
  fetchzip,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "mac-fdisk";
  version = "0.1.16";

  src = fetchzip {
    url = "https://deb.debian.org/debian/pool/main/m/mac-fdisk/mac-fdisk_0.1.orig.tar.gz";
    sha256 = "sha256-pYNyhPvRKdIje0Rpay0OzmrkGcl+/JOhMv7r+2LZk/Q=";
  };

  patches = [
    # patches from https://git.adelielinux.org/adelie/packages/-/tree/current/user/mac-fdisk
    # Debian's changeset, extracted into a patch
    ./mac-fdisk-0.1-debian.patch
    # Include a lot more headers and remove a bunch of braindead __linux__ checks
    ./mac-fdisk-0.1-headers.patch
    # Add support for more architectures
    ./mac-fdisk-0.1-more-arches.patch
    # From p16 (source?), adjusts some types & fixes PPC64 support
    ./mac-fdisk-0.1_p16-ppc64.patch
    # From p16 (source?), makes some inlines static
    ./mac-fdisk-0.1_p16-proper-inline.patch
    # Adds x86_64 support
    ./mac-fdisk-amd64.patch
    # Fix missing header in fdisk.c on musl
    ./mac-fdisk-fdisk-header-musl.patch
    # Support disks >550GB
    ./mac-fdisk-large-disk-support.patch
    # Enable Large File Support (>2GiB)
    ./mac-fdisk-largerthan2gb.patch
    # Fix compilation on non-glibc
    ./mac-fdisk-non-glibc-support.patch
    # Flush stdout after printing prompt for better UX
    ./flush-stdout.patch
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pdisk $out/sbin/mac-fdisk
    install -Dm755 fdisk $out/sbin/pmac-fdisk

    for manpage in {,p}mac-fdisk.8; do
      mv "$manpage".in $manpage
      installManPage $manpage
    done

    runHook postInstall
  '';

  meta = {
    description = "68K and PowerPC Mac disk partitioning utility, Adélie Linux version";
    # http://ftp.mklinux.apple.com:/pub/Other_Tools/ but that one's looong dead, link goes to the patch compilation we're using
    homepage = "https://git.adelielinux.org/adelie/packages/-/tree/master/user/mac-fdisk";
    license = with lib.licenses; [
      hpnd # original license statements seems to match this (in files that are shared with pdisk)
      gpl1Plus # fdisk.c
    ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # the toolchain that's being expected for Mac support (SCSI.h from Universal Headers 2.0, SIOUX.h from Metrowerks CoreWarrior) is ancient, unsure about BSDs
    platforms = lib.platforms.linux;
    badPlatforms = lib.platforms.aarch64; # missing some platform definitions
  };
}
