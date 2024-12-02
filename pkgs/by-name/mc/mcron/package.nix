{ fetchurl, lib, stdenv, guile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "mcron";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://gnu/mcron/mcron-${version}.tar.gz";
    sha256 = "0bkn235g2ia4f7ispr9d55c7bc18282r3qd8ldhh5q2kiin75zi0";
  };

  # don't attempt to chmod +s files in the nix store
  postPatch = ''
    sed -E -i '/chmod u\+s/d' Makefile.in
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ guile ];

  doCheck = true;

  meta = {
    description = "Flexible implementation of `cron' in Guile";

    longDescription = ''
      The GNU package mcron (Mellor's cron) is a 100% compatible
      replacement for Vixie cron.  It is written in pure Guile, and
      allows configuration files to be written in scheme (as well as
      Vixie's original format) for infinite flexibility in specifying
      when jobs should be run.  Mcron was written by Dale Mellor.
    '';

    homepage = "https://www.gnu.org/software/mcron/";

    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
