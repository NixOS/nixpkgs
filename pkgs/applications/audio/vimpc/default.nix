{ stdenv, fetchurl, autoconf, automake, mpd_clientlib, ncurses, pcre, pkgconfig, taglib }:

stdenv.mkDerivation rec {
  version = "0.09.0";
  name = "vimpc-${version}";

  src = fetchurl {
    url = "https://github.com/boysetsfrog/vimpc/archive/v${version}.tar.gz";
    sha256 = "13eb229a5e9eee491765ee89f7fe6a38140a41a01434b117da3869d725c15706";
  };

  buildInputs = [ autoconf
                  automake
                  mpd_clientlib
                  ncurses
                  pcre
                  pkgconfig
                  taglib
                ];

  preConfigure = "./autogen.sh";

  postInstall = ''
    mkdir -p $out/etc
    cp doc/vimpcrc.example $out/etc
  '';

  meta = {
    description = "A vi/vim inspired client for the Music Player Daemon (mpd).";
    homepage = https://github.com/boysetsfrog/vimpc;
    license = "GPL3";
    platforms = stdenv.lib.platforms.linux;
  };
}
