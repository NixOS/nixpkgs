{ stdenv, fetchgit, perl, libxcb, libXft }:

let
  version = "2015-07-23";
in
  stdenv.mkDerivation rec {
    name = "bar-xft-git-${version}";

    src = fetchgit {
      url = "https://github.com/krypt-n/bar";
      rev = "020a3e1848ce03287886e9ff80b0b443e9aed543";
      sha256 = "1xzs37syhlwyjfxnk36qnij5bqa0mi53lf1k851viw4qai2bfkgr";
    };

    buildInputs = [ libxcb libXft perl ];

    prePatch = ''sed -i "s@/usr@$out@" Makefile'';

    meta = {
      description = "A lightweight xcb based bar with XFT-support";
      homepage = https://github.com/krypt-n/bar;
      maintainers = [ stdenv.lib.maintainers.hiberno ];
      license = "Custom";
      platforms = stdenv.lib.platforms.linux;
    };
}
