{ lib, stdenv, fetchurl, fetchpatch, openssl, ncurses, pkg-config, glib, loudmouth, libotr
, gpgme
}:

stdenv.mkDerivation rec {
  pname = "mcabber";
  version = "1.1.2";

  src = fetchurl {
    url = "https://mcabber.com/files/mcabber-${version}.tar.bz2";
    sha256 = "0q1i5acyghsmzas88qswvki8kkk2nfpr8zapgnxbcd3lwcxl38f4";
  };

  patches = [
    # Pull upstream patch for ncurses-6.3.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/McKael/mcabber/commit/5a0893d69023b77b7671731defbdca5d47731130.patch";
      sha256 = "01bc23z0mva9l9jv587sq2r9w3diachgkmb9ad99hlzgj02fmq4v";
      stripLen = 1;
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ncurses glib loudmouth libotr gpgme ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--enable-modules"
    "--enable-otr"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://mcabber.com/";
    description = "Small Jabber console client";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    updateWalker = true;
    downloadPage = "http://mcabber.com/files/";
    downloadURLRegexp = "mcabber-[0-9.]+[.]tar[.][a-z0-9]+$";
  };
}
