{
  fetchurl,
  lib,
  stdenv,
  fetchpatch2,
}:

stdenv.mkDerivation rec {
  pname = "acct";
  version = "6.6.4";

  src = fetchurl {
    url = "mirror://gnu/acct/acct-${version}.tar.gz";
    hash = "sha256-TBW/K1ixY3i8yD9w531NQKsLGUrPLr7v21B/FR+qZj8=";
  };

  doCheck = true;

  patches = [
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/psacct/raw/rawhide/f/psacct-6.6.4-sprintf-buffer-overflow.patch";
      hash = "sha256-l74tLIuhpXj+dIA7uAY9L0qMjQ2SbDdc+vjHMyVouFc=";
    })
  ];

  meta = {
    description = "GNU Accounting Utilities, login and process accounting utilities";

    longDescription = ''
      The GNU Accounting Utilities provide login and process accounting
      utilities for GNU/Linux and other systems.  It is a set of utilities
      which reports and summarizes data about user connect times and process
      execution statistics.
    '';

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/acct/";

    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
}
