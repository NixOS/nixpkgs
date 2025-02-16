{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  version = "0.99";
  pname = "barcode";
  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1indapql5fjz0bysyc88cmc54y8phqrbi7c76p71fgjp45jcyzp8";
  };
  patches = [
    # Pull upstream patch for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "http://git.savannah.gnu.org/cgit/barcode.git/patch/?id=4654f68706a459c9602d9932b56a56e8930f7d53";
      sha256 = "15kclzcwlh0ymr7m48vc0m8z98q0wf4xbfcky4g1y8yvvpvvrfgc";
    })
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "ac_cv_func_calloc_0_nonnull=yes";

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GNU barcode generator";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    downloadPage = "https://ftp.gnu.org/gnu/barcode/";
    homepage = "https://www.gnu.org/software/barcode/";
    license = licenses.gpl3;
  };
}
