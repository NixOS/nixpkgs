args: with args;

let inherit (args.composableDerivation) composableDerivation edf wwf; in

composableDerivation {} ( fixed : {

  name = "yate2";

  src = fetchurl {
    url = http://yate.null.ro/tarballs/yate2/yate2.tar.gz;
    sha256 = "1z1rvzcw6449cvczig1dkh6rlp6f8zv649sk0ldz38mwkyd07257";
  };

  # TODO zaptel ? postgres ?
  buildInputs = [qt openssl autoconf automake pkgconfig];

  # /dev/null is used when linking which is a impure path for the wrapper
  preConfigure = "
  
  sed -i 's@,/dev/null@@' configure
  "; 

  # --unresolved-symbols=ignore-in-shared-libs makes ld no longer find --library=yate? Why?
  preBuild = ''
    export NIX_LDFLAGS="-L$TMP/yate $NIX_LDFLAGS"
    find . -type f -iname Makefile | xargs sed -i \
      -e 's@-Wl,--unresolved-symbols=ignore-in-shared-libs@@' \
      -e 's@-Wl,--retain-symbols-file@@'
  '';

  meta = { 
    description = "YATE - Yet Another Telephony Engine";
    homepage = http://yate.null.ro/;
    license = ["GPL" "MPL"]; # Yate's license is GPL with an exception for linking with OpenH323 and PWlib (licensed under MPL).
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };

} )
