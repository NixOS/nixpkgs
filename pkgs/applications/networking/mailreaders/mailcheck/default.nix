{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mailcheck-${version}";
  version = "1.91.2";

  patches = [ ./mailcheck-Makefile.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/mailcheck/mailcheck_${version}.tar.gz";
    sha256 = "0p0azaxsnjvjbg41ycicc1i0kzw6jiynq8k49cfkdhlckxfdm9kc";
  };

  meta = {
    description = "Simple command line tool to check for new messages";
    homepage    = http://mailcheck.sourceforge.net/;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    platforms   = stdenv.lib.platforms.linux;
    inherit version;

    longDescription = ''
      A simple command line tool to check for new mail in local mbox and
      maildir and remote POP3 and IMAP mailboxes.
    '';
  };
}
