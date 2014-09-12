{ stdenv, fetchurl
, pkgconfig
, autoconf, automake, intltool, gettext
, gtk, vte }:

stdenv.mkDerivation rec {

  name = "lilyterm-${version}";
  version = "0.9.9.4";

  src = fetchurl {
    url = "http://lilyterm.luna.com.tw/file/${name}.tar.gz";
    sha256 = "0x2x59qsxq6d6xg5sd5lxbsbwsdvkwqlk17iw3h4amjg3m1jc9mp";
  };

  buildInputs = [ pkgconfig autoconf automake intltool gettext gtk vte ];

  preConfigure = "sh autogen.sh";

  configureFlags = ''
    --enable-nls
    --enable-safe-mode
  '';

  meta = with stdenv.lib; {
    description = "A fast, lightweight terminal emulator";
    longDescription = ''
      LilyTerm is a terminal emulator based off of libvte that aims to be fast and lightweight.
    '';
    homepage = http://lilyterm.luna.com.tw/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
