{ stdenv, fetchhg, autoconf, automake, ncurses, which
, perl, gdbm, openssl, cyrus_sasl, gpgme, libidn }:

let
  version = "1.5.23-rel";
in
stdenv.mkDerivation rec {
  name = "mutt-${version}";
  
  src = fetchhg {
    url = "http://dev.mutt.org/hg/mutt/";
    rev = "mutt-${version}";
    sha256 =  "1m0aif066lsc0936ha9s1kfx63wsl1l1wiib7ax6xgzijawd80pp";
  };

  enableParallelBuilding = true;

  buildInputs = [
    autoconf automake ncurses which perl
    gdbm openssl cyrus_sasl gpgme libidn
  ];

  # This patch is necessary, because during the configure phase mutt
  # searches for some paths to store mail in that do not exist on
  # NixOS, like /var/mail, /usr/mail and similiar. This patch adds
  # /tmp to the list.
  patches = [
    ./mailpath.patch
  ];

  preConfigure = ''./prepare'';

  configureFlags = [
    "--prefix=$out"

    "--enable-debug"
    "--enable-gpgme"
    "--enable-hcache"
    "--enable-imap"
    "--enable-pop"
    "--enable-smtp"

    "--with-idn"
    "--with-regex"
    "--with-ssl"
    "--with-sasl"
  ];
   
  meta = with stdenv.lib; {
    description = "A small but very powerful text-based mail client";
    homepage = http://www.mutt.org;
    license = "GPLv2+";
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny _1126 ];
  };
}

