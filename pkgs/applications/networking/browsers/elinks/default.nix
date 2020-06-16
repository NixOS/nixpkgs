{ stdenv, fetchurl, fetchpatch, ncurses, xlibsWrapper, bzip2, zlib, brotli, openssl, autoconf, automake, gettext, pkgconfig, libev
, gpm
, # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile        ? false,                                         guile ? null
, enablePython       ? false,                                         python ? null
, enablePerl         ? (stdenv.hostPlatform == stdenv.buildPlatform), perl ? null
, enableSpidermonkey ? (stdenv.hostPlatform == stdenv.buildPlatform), spidermonkey ? null
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "elinks-0.13.2";
  version = "0.13.2";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/e/elinks/elinks_${version}.orig.tar.gz";
    sha256 = "0xkpqnqy0x8sizx4snca0pw3q98gkhnw5a05yf144j1x1y2nb14c";
  };

  patches = map fetchurl (import ./debian-patches.nix);

  postPatch = (stdenv.lib.optional stdenv.isDarwin) ''
    patch -p0 < ${fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/72bed7749e76b9092ddd8d9fe2d8449c5afb1d71/www/elinks/files/patch-perl.diff";
      sha256 = "14q9hk3kg2n2r5b062hvrladp7b4yzysvhq07903w9kpg4zdbyqh";
    }}
  '';

  buildInputs = [ ncurses xlibsWrapper bzip2 zlib brotli openssl libev ]
    ++ stdenv.lib.optional stdenv.isLinux gpm
    ++ stdenv.lib.optional enableGuile guile
    ++ stdenv.lib.optional enablePython python
    ++ stdenv.lib.optional enablePerl perl
    ++ stdenv.lib.optional enableSpidermonkey spidermonkey
    ;
  
  nativeBuildInputs = [ autoconf automake gettext pkgconfig ];

  configureFlags = [
    "--enable-finger"
    "--enable-html-highlight"
    "--enable-gopher"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--enable-256-colors"
    "--with-libev"
  ] ++ stdenv.lib.optional enableGuile        "--with-guile"
    ++ stdenv.lib.optional enablePython       "--with-python"
    ++ stdenv.lib.optional enablePerl         "--with-perl"
    ++ stdenv.lib.optional enableSpidermonkey "--with-spidermonkey=${spidermonkey}"
    ;
  
  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Full-featured text-mode web browser (package based on the fork felinks)";
    homepage = "https://github.com/rkd77/felinks";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ iblech ];
  };
}
