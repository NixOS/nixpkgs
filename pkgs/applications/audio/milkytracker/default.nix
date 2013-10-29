{ stdenv, fetchurl, alsaLib, SDL, automake, autoconf, perl}:

stdenv.mkDerivation rec {
  version = "0.90.85";
  name = "milkytracker-${version}";

  src = fetchurl {
    url = "http://milkytracker.org/files/milkytracker-0.90.85.tar.gz";
    sha256 = "184pk0k9nv461a61sh6lb62wfadjwwk8ri3z5kpdbqnyssz0zfpv";
  };

  # Get two official patches.
  no_zzip_patch = fetchurl {
    url = "http://www.milkytracker.org/files/patches-0.90.85/no_zziplib_dep.patch";
    sha256 = "1w550q7pxa7w6v2v19ljk03hayacrs6y887izg11a1983wk7qzb3";
      };

  fix_64bit_patch = fetchurl {
    url = "http://www.milkytracker.org/files/patches-0.90.85/64bit_freebsd_fix.patch";
    sha256 = "0gwd4zslbd8kih80k4v7n2c65kvm2cq3kl6d7y33z1l007vzyvf6";
  };

  preConfigure = ''
   patch ./src/tracker/sdl/SDL_Main.cpp < ${fix_64bit_patch}
   patch < ${no_zzip_patch}
  '';

  # There's a zlib version included with milkytracker,
  # but there's no makefiles for it. I've only included
  # the header here, but it fails at link-time with
  # several 'undefined reference' errors, which simply
  # means it can't find the definitions, e.g. compiled
  # zlib.
  # There's bug reports on other package systems although
  # unfortunately still unresolved.
  # https://bugs.archlinux.org/task/31324
  # http://lists.freebsd.org/pipermail/freebsd-ports/2013-March/082180.html
  preBuild=''
    export CPATH="`pwd`/src/compression/zlib/generic"
  '';

  buildInputs = [ alsaLib SDL automake autoconf perl];

  meta = {
    description = "Music tracker application, similar to Fasttracker II.";
    homepage = http://milkytracker.org;
    license = "GPLv3";
  };
}
