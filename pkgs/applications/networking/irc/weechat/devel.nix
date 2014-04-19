{ stdenv, fetchgit, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  rev = "6f64ee699ba46c90b55d3b99c60e4807819e2b7b";
  version = "0.4.4-rev${rev}";
  name = "weechat-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/weechat/weechat.git";
    sha256 = "1w58gir48kxvscf6njy3kmfxbjlnsf2byw3g3w6r47zjkgyxcf1z";
  };

  buildInputs = 
    [ ncurses perl python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt ruby lua5 tcl guile pythonPackages.pycrypto makeWrapper
      cacert cmake
    ];

  postInstall = ''
       wrapProgram "$out/bin/weechat" \
         --prefix PYTHONPATH : "$PYTHONPATH" \
         --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages"
  '';

  meta = {
    homepage = http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ garbas the-kenny ];
    platforms = stdenv.lib.platforms.linux;
  };
}
