{ stdenv, fetchurl, lib, qt4, openssl, autoconf, automake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yate-${version}";
  version = "6.0.0-1";

  src = fetchurl {
    url = "http://voip.null.ro/tarballs/yate${lib.versions.major version}/${name}.tar.gz";
    sha256 = "05qqdhi3rp5660gq1484jkmxkm9vq81j0yr765h0gf0xclan1dqa";
  };

  # TODO zaptel ? postgres ?
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ qt4 openssl autoconf automake ];

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
    homepage = http://yate.null.ro/;
    # Yate's license is GPL with an exception for linking with
    # OpenH323 and PWlib (licensed under MPL).
    license = ["GPL" "MPL"];
    maintainers = [ lib.maintainers.marcweber ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
