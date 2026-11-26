{
  lib,
  stdenv,
  fetchurl,
  withSaidar ? true,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstatgrab";
  version = "0.92.2";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-/1WfzU2nWkAjr5hsAsUq1R1LaK6D/AyMRhAmEmqOvvo=";
  };

  buildInputs = lib.optional withSaidar ncurses;

  meta = {
    homepage = "https://www.i-scream.org/libstatgrab/";
    description = "Library that provides cross platforms access to statistics about the running system";
    maintainers = [ ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
