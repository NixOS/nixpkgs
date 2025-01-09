{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  libcap,
  zlib,
  bzip2,
  perl,
  quilt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrkit";
  version = "1.1.11-3.5";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "cdrkit";
    rev = "debian/9%${finalAttrs.version}";
    hash = "sha256-T7WhztbpVvGegF6rTHGTkEALq+mcAtTerzDQ3f6Cq78=";
  };

  nativeBuildInputs = [
    cmake
    quilt
  ];
  buildInputs = [
    zlib
    bzip2
    perl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isMusl [
      "-D__THROW="
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=int-conversion"
    ]
  );

  postPatch =
    ''
      QUILT_PATCHES=debian/patches quilt push -a
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
})
