{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libcap,
  zlib,
  bzip2,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "cdrkit";
  version = "1.1.11";

  src = fetchurl {
    url = "http://cdrkit.org/releases/cdrkit-${version}.tar.gz";
    sha256 = "1nj7iv3xrq600i37na9a5idd718piiiqbs4zxvpjs66cdrsk1h6i";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    bzip2
    perl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  hardeningDisable = [ "format" ];
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isMusl [
      "-D__THROW="
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=int-conversion"
      "-Wno-error=implicit-function-declaration"
    ]
  );

  # efi-boot-patch extracted from http://arm.koji.fedoraproject.org/koji/rpminfo?rpmID=174244
  patches = [
    ./include-path.patch
    ./cdrkit-1.1.9-efi-boot.patch
    ./cdrkit-1.1.11-fno-common.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace libusal/scsi-mac-iokit.c \
      --replace "IOKit/scsi-commands/SCSITaskLib.h" "IOKit/scsi/SCSITaskLib.h"
    substituteInPlace genisoimage/sha256.c \
      --replace "<endian.h>" "<machine/endian.h>"
    substituteInPlace genisoimage/sha512.c \
      --replace "<endian.h>" "<machine/endian.h>"
    substituteInPlace genisoimage/sha256.h \
      --replace "__THROW" ""
    substituteInPlace genisoimage/sha512.h \
      --replace "__THROW" ""
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace include/xconfig.h.in \
        --replace "#define HAVE_RCMD 1" "#undef HAVE_RCMD"
  '';

  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace  */CMakeFiles/*.dir/link.txt \
      --replace-warn "-lrt" "-framework IOKit -framework CoreFoundation"
  '';

  postInstall = ''
    # file name compatibility with the old cdrecord (growisofs wants this name)
    ln -s $out/bin/genisoimage $out/bin/mkisofs
    ln -s $out/bin/wodim $out/bin/cdrecord
  '';

  cmakeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "-DBITFIELDS_HTOL=0" ];

  makeFlags = [ "PREFIX=\$(out)" ];

  meta = {
    description = "Portable command-line CD/DVD recorder software, mostly compatible with cdrtools";

    longDescription = ''
      Cdrkit is a suite of programs for recording CDs and DVDs,
      blanking CD-RW media, creating ISO-9660 filesystem images,
      extracting audio CD data, and more.  The programs included in
      the cdrkit package were originally derived from several sources,
      most notably mkisofs by Eric Youngdale and others, cdda2wav by
      Heiko Eissfeldt, and cdrecord by Jörg Schilling.  However,
      cdrkit is not affiliated with any of these authors; it is now an
      independent project.
    '';

    homepage = "http://cdrkit.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
