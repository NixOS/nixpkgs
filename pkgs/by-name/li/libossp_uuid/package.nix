{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libossp-uuid";
  version = "1.6.2";

  src = fetchurl {
    url = "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-${version}.tar.gz";
    sha256 = "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0";
  };

  configureFlags = [
    "ac_cv_va_copy=yes"
  ] ++ lib.optional stdenv.hostPlatform.isFreeBSD "--with-pic";

  patches = [ ./shtool.patch ];

  meta = with lib; {
    homepage = "http://www.ossp.org/pkg/lib/uuid/";
    description = "OSSP uuid ISO-C and C++ shared library";
    longDescription = ''
      OSSP uuid is a ISO-C:1999 application programming interface
      (API) and corresponding command line interface (CLI) for the
      generation of DCE 1.1, ISO/IEC 11578:1996 and RFC 4122
      compliant Universally Unique Identifier (UUID). It supports
      DCE 1.1 variant UUIDs of version 1 (time and node based),
      version 3 (name based, MD5), version 4 (random number based)
      and version 5 (name based, SHA-1). Additional API bindings are
      provided for the languages ISO-C++:1998, Perl:5 and
      PHP:4/5. Optional backward compatibility exists for the ISO-C
      DCE-1.1 and Perl Data::UUID APIs.

      UUIDs are 128 bit numbers which are intended to have a high
      likelihood of uniqueness over space and time and are
      computationally difficult to guess. They are globally unique
      identifiers which can be locally generated without contacting
      a global registration authority. UUIDs are intended as unique
      identifiers for both mass tagging objects with an extremely
      short lifetime and to reliably identifying very persistent
      objects across a network.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
