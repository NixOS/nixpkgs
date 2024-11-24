{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "acct";
  version = "6.6.4";

  src = fetchurl {
    url = "mirror://gnu/acct/acct-${version}.tar.gz";
    sha256 = "0gv6m8giazshvgpvwbng98chpas09myyfw1zr2y7hqxib0mvy5ac";
  };

  doCheck = true;

  meta = with lib; {
    description = "GNU Accounting Utilities, login and process accounting utilities";

    longDescription = ''
      The GNU Accounting Utilities provide login and process accounting
      utilities for GNU/Linux and other systems.  It is a set of utilities
      which reports and summarizes data about user connect times and process
      execution statistics.
    '';

    license = licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/acct/";

    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
