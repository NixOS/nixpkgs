{ stdenv, fetchurl, lib, qt4, openssl, autoconf, automake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "yate-${version}";
  version = "5.4.2-1";

  src = fetchurl {
    url = "http://voip.null.ro/tarballs/yate5/${name}.tar.gz";
    sha256 = "08gwz0gipc5v75jv46p2yg8hg31xjp6x7jssd0rrgsa3szi5697n";
  };

  # TODO zaptel ? postgres ?
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ qt4 openssl autoconf automake ];

  # /dev/null is used when linking which is a impure path for the wrapper
  preConfigure =
    ''
      sed -i 's@,/dev/null@@' configure
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
    platforms = lib.platforms.linux;
  };

}
