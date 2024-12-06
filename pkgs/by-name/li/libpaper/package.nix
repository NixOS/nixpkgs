{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.1.29";
  pname = "libpaper";

  src = fetchurl {
    url = "mirror://debian/pool/main/libp/libpaper/libpaper_${version}.tar.gz";
    hash = "sha256-JjMOIemjEkZY1RX9hQsM3lRv9C2JsllqUmTF8Wd/BUc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # The configure script of libpaper is buggy: it uses AC_SUBST on a headerfile
  # to compile sysconfdir into the library. Autoconf however defines sysconfdir
  # as "${prefix}/etc", which is not expanded by AC_SUBST so libpaper will look
  # for config files in (literally, without expansion) '${prefix}/etc'. Manually
  # setting sysconfdir fixes this issue.
  preConfigure = ''
    configureFlagsArray+=(
      "--sysconfdir=$out/etc"
    )
  '';

  # Set the default paper to letter (this is what libpaper uses as default as well,
  # if you call getdefaultpapername()).
  # The user can still override this with the PAPERCONF environment variable.
  postInstall = ''
    mkdir -p $out/etc
    echo letter > $out/etc/papersize
  '';

  meta = {
    description = "Library for handling paper characteristics";
    homepage = "http://packages.debian.org/unstable/source/libpaper";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
