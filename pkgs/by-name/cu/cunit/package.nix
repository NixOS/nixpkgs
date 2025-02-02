{ lib, stdenv, fetchurl, autoconf, automake, libtool, autoreconfHook}:

stdenv.mkDerivation rec {
  pname = "CUnit";
  version = "2.1-3";

  nativeBuildInputs = [ autoreconfHook autoconf automake ];
  buildInputs = [libtool];

  src = fetchurl {
    url = "mirror://sourceforge/cunit/CUnit/${version}/CUnit-${version}.tar.bz2";
    sha256 = "057j82da9vv4li4z5ri3227ybd18nzyq81f6gsvhifs5z0vr3cpm";
  };

  meta = {
    description = "Unit Testing Framework for C";

    longDescription = ''
      CUnit is a lightweight system for writing, administering, and running
      unit tests in C.  It provides C programmers a basic testing functionality
      with a flexible variety of user interfaces.
    '';

    homepage = "https://cunit.sourceforge.net/";

    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
