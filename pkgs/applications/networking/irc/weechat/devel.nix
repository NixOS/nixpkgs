{ stdenv, fetchgit, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  rev = "85b8e0d82bf99ca2c55a87482ee40b3043df14db";
  version = "0.4.4-rev${rev}";
  name = "weechat-${version}";

  src = fetchgit {
    inherit rev;
    url    = "git://github.com/weechat/weechat.git";
    sha256 = "0kzsar7gmw2sgkdzcspg65prii8skpaqxvdyvas2a29dr07j2gnl";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin pythonPackages.pync;

  NIX_CFLAGS_COMPILE = "-I${python}/include/python2.7";

  postInstall = ''
    NIX_PYTHONPATH="$out/lib/${python.libPrefix}/site-packages"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    NIX_PYTHONPATH+="${pythonPackages.pync}/lib/${python.libPrefix}/site-packages"
  '' + ''
     wrapProgram "$out/bin/weechat" \
       --prefix PYTHONPATH : "$PYTHONPATH" \
       --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages"
  '';

  meta = {
    homepage    = http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license     = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
