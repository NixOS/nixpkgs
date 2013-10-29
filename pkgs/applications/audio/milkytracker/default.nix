{ stdenv, fetchurl, SDL, alsaLib, autoconf, automake, jackaudio, perl
, zlib, zziplib
}:

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

  patchPhase = ''
    patch ./src/tracker/sdl/SDL_Main.cpp < ${fix_64bit_patch}
    patch < ${no_zzip_patch}
    patch ./src/compression/DecompressorGZIP.cpp < ${./decompressor_gzip.patch}
  '';

  preBuild=''
    export CPATH=${zlib}/lib
  '';

  buildInputs = [ SDL alsaLib autoconf automake jackaudio perl zlib zziplib ];

  meta = {
    description = "Music tracker application, similar to Fasttracker II.";
    homepage = http://milkytracker.org;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
