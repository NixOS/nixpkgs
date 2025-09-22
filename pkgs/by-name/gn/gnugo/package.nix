{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "gnugo";
  version = "3.8";

  src = fetchurl {
    url = "mirror://gnu/gnugo/gnugo-${version}.tar.gz";
    sha256 = "0wkahvqpzq6lzl5r49a4sd4p52frdmphnqsfdv7gdp24bykdfs6s";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://savannah.gnu.org/patch/index.php?10208
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://savannah.gnu.org/patch/download.php?file_id=53240";
      sha256 = "0s96qvmx244vq5pv2nzf7x863kq2y5skzjhbpyzaajfkldbj0sw4";
    })
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "GNU Go - A computer go player";
    mainProgram = "gnugo";
    homepage = "https://www.gnu.org/software/gnugo/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
