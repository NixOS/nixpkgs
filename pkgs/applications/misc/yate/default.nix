{ stdenv, fetchurl, lib, qt4, openssl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "yate";
  version = "6.1.0-1";

  src = fetchurl {
    url = "http://voip.null.ro/tarballs/yate${lib.versions.major version}/${pname}-${version}.tar.gz";
    sha256 = "0xx3i997nsf2wzbv6m5n6adsym0qhgc6xg4rsv0fwqrgisf5327d";
  };

  # TODO zaptel ? postgres ?
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ qt4 openssl ];

  # /dev/null is used when linking which is a impure path for the wrapper
  preConfigure =
    ''
      sed -i 's@,/dev/null@@' configure
      patchShebangs configure
    '';

  # --unresolved-symbols=ignore-in-shared-libs makes ld no longer find --library=yate? Why?
  preBuild =
    ''
      export NIX_LDFLAGS="-L$TMP/yate $NIX_LDFLAGS"
      find . -type f -iname Makefile | xargs sed -i \
        -e 's@-Wl,--unresolved-symbols=ignore-in-shared-libs@@' \
        -e 's@-Wl,--retain-symbols-file@@'
    '';

  meta = {
    description = "Yet another telephony engine";
    homepage = "http://yate.null.ro/";
    # Yate's license is GPL with an exception for linking with
    # OpenH323 and PWlib (licensed under MPL).
    license = ["GPL" "MPL"];
    maintainers = [ lib.maintainers.marcweber ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
