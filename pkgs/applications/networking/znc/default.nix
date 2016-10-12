{ stdenv, fetchgit, openssl, pkgconfig, autoreconfHook
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "znc-1.6.4-dev";

  src = fetchgit {
    url = "https://github.com/znc/znc";
    rev = "ddec5c27bacb934bf720fd9c0db89cc3fdcb2e29";
    sha256 = "0bqib1ddn52ppbv008shql0xrg5185ynmabz548i4msydl5990jc";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl pkgconfig ]
    ++ optional withPerl perl
    ++ optional withPython python3
    ++ optional withTcl tcl
    ++ optional withCyrus cyrus_sasl;

  configureFlags = optionalString withPerl "--enable-perl "
    + optionalString withPython "--enable-python "
    + optionalString withTcl "--enable-tcl --with-tcl=${tcl}/lib "
    + optionalString withCyrus "--enable-cyrus ";

  meta = with stdenv.lib; {
    description = "Advanced IRC bouncer";
    homepage = http://wiki.znc.in/ZNC;
    maintainers = with maintainers; [ viric ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
