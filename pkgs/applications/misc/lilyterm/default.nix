{ stdenv, fetchurl, fetchFromGitHub
, pkgconfig
, autoconf, automake, intltool, gettext
, gtk, vte

# "stable" or "git"
, flavour ? "stable"
}:

assert flavour == "stable" || flavour == "git";

let
  stuff =
    if flavour == "stable"
    then rec {
        version = "0.9.9.4";
        src = fetchurl {
          url = "http://lilyterm.luna.com.tw/file/lilyterm-${version}.tar.gz";
          sha256 = "0x2x59qsxq6d6xg5sd5lxbsbwsdvkwqlk17iw3h4amjg3m1jc9mp";
        };
      }
    else {
        version = "2017-01-06";
        src = fetchFromGitHub {
          owner = "Tetralet";
          repo = "lilyterm";
          rev = "20cce75d34fd24901c9828469d4881968183c389";
          sha256 = "0am0y65674rfqy69q4qz8izb8cq0isylr4w5ychi40jxyp68rkv2";
        };
      };

in
stdenv.mkDerivation rec {
  name = "lilyterm-${version}";

  inherit (stuff) src version;

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
    maintainers = with maintainers; [ AndersonTorres profpatsch ];
    platforms = platforms.linux;
  };
}
