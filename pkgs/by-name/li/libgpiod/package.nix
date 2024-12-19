{ lib, stdenv, fetchurl, autoreconfHook, autoconf-archive, pkg-config
, enable-tools ? true }:

stdenv.mkDerivation rec {
  pname = "libgpiod";
  version = "2.2";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${version}.tar.gz";
    hash = "sha256-rjUynbcCfHQOkMiDuvJ8JjEfBhTmp7EVdxsoGIuZKuw=";
  };

  nativeBuildInputs = [
    autoconf-archive
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-tools=${if enable-tools then "yes" else "no"}"
    "--enable-bindings-cxx"
  ];

  meta = with lib; {
    description = "C library and tools for interacting with the linux GPIO character device";
    longDescription = ''
      Since linux 4.8 the GPIO sysfs interface is deprecated. User space should use
      the character device instead. This library encapsulates the ioctl calls and
      data structures behind a straightforward API.
    '';
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license = with licenses; [
      lgpl21Plus # libgpiod
      lgpl3Plus # C++ bindings
    ] ++ lib.optional enable-tools gpl2Plus;
    maintainers = [];
    platforms = platforms.linux;
  };
}
