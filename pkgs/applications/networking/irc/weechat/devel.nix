{ stdenv, fetchgit, ncurses, openssl, perl, python, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt, ruby, lua5, tcl, guile
, pythonPackages, cacert, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  rev = "02eed97d977567b0fb16cfeeaeebb863eab1e509";
  version = "1.0-rev${rev}";
  name = "weechat-${version}";

  src = fetchgit {
    inherit rev;
    url = "git://github.com/weechat/weechat.git";
    sha256 = "0nk0p9chvn0h2pzq9793k2dz8h5iplz0zwqzyds55fbmsgzz51g2";
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
