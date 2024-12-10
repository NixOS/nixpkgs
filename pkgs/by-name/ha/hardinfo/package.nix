{
  lib,
  stdenv,
  fetchurl,
  which,
  pkg-config,
  gtk2,
  pcre,
  glib,
  libxml2,
  libsoup ? null,
}:

stdenv.mkDerivation rec {
  pname = "hardinfo";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/hardinfo.berlios/hardinfo-${version}.tar.bz2";
    sha256 = "0yhvfc5icam3i4mphlz0m9d9d2irjw8mbsxq203x59wjgh6nrpx0";
  };

  # Not adding 'hostname' command, the build shouldn't depend on what the build
  # host is called.
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    which
    gtk2
    pcre
    glib
    libxml2
    libsoup
  ];

  # Fixes '#error You must compile this program without "-O"'
  hardeningDisable = [ "all" ];

  # Ignore undefined references to a bunch of libsoup symbols
  NIX_LDFLAGS = "--unresolved-symbol=ignore-all";

  preConfigure = ''
    patchShebangs configure

    # -std=gnu89 fixes build error, copied from
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757525
    sed -i -e "s/^CFLAGS = \(.*\)/CFLAGS = \1 -std=gnu89/" Makefile.in

    substituteInPlace ./arch/linux/common/modules.h --replace /sbin/modinfo modinfo
    substituteInPlace ./arch/linux/common/os.h --replace /lib/libc.so.6 ${stdenv.cc.libc}/lib/libc.so
  '';

  # Makefile supports DESTDIR but not PREFIX (it hardcodes $DESTDIR/usr/).
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv "$out/usr/"* "$out"
    rmdir "$out/usr"
  '';

  meta = with lib; {
    homepage = "http://hardinfo.org/";
    description = "Display information about your hardware and operating system";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bjornfor ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ]; # ARMv7 and AArch64 are unsupported
    mainProgram = "hardinfo";
  };
}
