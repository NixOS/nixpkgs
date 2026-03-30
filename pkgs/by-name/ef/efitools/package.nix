{
  lib,
  stdenv,
  gnu-efi,
  openssl,
  sbsigntool,
  perl,
  perlPackages,
  help2man,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "efitools";
  version = "1.9.2";

  buildInputs = [
    gnu-efi
    openssl
    sbsigntool
  ];

  nativeBuildInputs = [
    perl
    perlPackages.FileSlurp
    help2man
  ];

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/efitools-v${finalAttrs.version}.tar.gz";
    sha256 = "0jabgl2pxvfl780yvghq131ylpf82k7banjz0ksjhlm66ik8gb1i";
  };

  patches = [
    # https://github.com/ncroxon/gnu-efi/issues/7#issuecomment-2122741592
    ./aarch64.patch

    # Fix build with gcc15
    ./remove-redundant-bool.patch
  ];

  postPatch = ''
    sed -i -e 's#/usr/include/efi#${gnu-efi}/include/efi/#g' Make.rules
    sed -i -e 's#/usr/lib64/gnuefi#${gnu-efi}/lib/#g' Make.rules
    sed -i -e 's#$(DESTDIR)/usr#$(out)#g' Make.rules
    sed -i '$asign-efi-sig-list.o flash-var.o: CFLAGS += -D_GNU_SOURCE' Makefile
    substituteInPlace lib/console.c --replace "EFI_WARN_UNKOWN_GLYPH" "EFI_WARN_UNKNOWN_GLYPH"
    patchShebangs .
  '';

  meta = {
    description = "Tools for manipulating UEFI secure boot platforms";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
