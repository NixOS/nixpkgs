{
  stdenv,
  lib,
  fetchzip,
  fetchpatch,
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
    # Debian's changeset, extracted into a patch
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1b708c8a90e3548c4954c6367a9376f76f3746bd/user/mac-fdisk/mac-fdisk-0.1-debian.patch";
      hash = "sha256-a9pGF+UsFeZiXgracmT4anqgpmcGcS/W3jGtFzHZtt4=";
    })
    # Include a lot more headers and remove a bunch of braindead __linux__ checks
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-0.1-headers.patch";
      hash = "sha256-FIk9K+lP+3e1pgmNfymTdpdSoTpBDv29kmwYgqYwWQw=";
    })
    # Add support for more architectures
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1b708c8a90e3548c4954c6367a9376f76f3746bd/user/mac-fdisk/mac-fdisk-0.1-more-arches.patch";
      hash = "sha256-HNRmzETUmKfZQFrjg6Y/HPwUnLk0vO5DokfU4umdOm0=";
    })
    # From p16 (source?), adjusts some types & fixes PPC64 support
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-0.1_p16-ppc64.patch";
      hash = "sha256-GK0nfga59nOXotkbKI+2ejA9TtyZUwDIxuXWFGGbeFg=";
    })
    # From p16 (source?), makes some inlines static
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-0.1_p16-proper-inline.patch";
      hash = "sha256-wr2teKpm0FyqNudKYlTD49pTFDis33Fo+0LULNYIJko=";
    })
    # Adds x86_64 support
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1b708c8a90e3548c4954c6367a9376f76f3746bd/user/mac-fdisk/mac-fdisk-amd64.patch";
      hash = "sha256-iO4/sY5sGKQyymMmAOb/TlCc9id2qgEDw7E8pFZpsHI=";
    })
    # Fix missing header in fdisk.c on musl
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-fdisk-header-musl.patch";
      hash = "sha256-mKBVjvLKtxKPADeoPqp17YdJ1QWj2enAYhKKSqTnQ44=";
    })
    # Support disks >550GB
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-large-disk-support.patch";
      hash = "sha256-IXZZdozqZKyZEz87ZzB8Jof22GgvHf4GaXBqSKn8su8=";
    })
    # Enable Large File Support (>2GiB)
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-largerthan2gb.patch";
      hash = "sha256-ATK7QYXV7BOk8iIFeXY8g+ZHLuuhww9pcrqOMDn/oLM=";
    })
    # Fix compilation on non-glibc
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/1fa4c88ee21866eeb0feae8f6b0bf609a04711cc/user/mac-fdisk/mac-fdisk-non-glibc-support.patch";
      hash = "sha256-CBZUKf7dPvvpuG5L+SI1FQ4W7/fDgeKXHUMFkJNu/MY=";
    })
    # Flush stdout after printing prompt for better UX
    (fetchpatch {
      url = "https://git.adelielinux.org/adelie/packages/-/raw/656ae6bf9f8a64aee95c4797b20bfe713627f1f4/user/mac-fdisk/flush-stdout.patch";
      hash = "sha256-k7+UPiUf/oCQdDhxDcC+FRwkxS89WSsYzFw6fUB/10I=";
    })
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

  meta = with lib; {
    description = "68K and PowerPC Mac disk partitioning utility, Adélie Linux version";
    # http://ftp.mklinux.apple.com:/pub/Other_Tools/ but that one's looong dead, link goes to the patch compilation we're using
    homepage = "https://git.adelielinux.org/adelie/packages/-/tree/master/user/mac-fdisk";
    license = with licenses; [
      hpnd # original license statements seems to match this (in files that are shared with pdisk)
      gpl1Plus # fdisk.c
    ];
    maintainers = with maintainers; [ OPNA2608 ];
    # the toolchain that's being expected for Mac support (SCSI.h from Universal Headers 2.0, SIOUX.h from Metrowerks CoreWarrior) is ancient, unsure about BSDs
    platforms = platforms.linux;
    badPlatforms = platforms.aarch64; # missing some platform definitions
  };
}
