{ stdenv, lib, fetchurl, fetchFromGitHub
, pkgconfig
, autoconf, automake, intltool, gettext
, gtk, vte
, flavour ? "stable"
}:

assert lib.assertOneOf "flavour" flavour [ "stable"  "git" ];

let
  pname = "lilyterm";
  stuff =
    if flavour == "stable"
    then rec {
        version = "0.9.9.4";
        src = fetchurl {
          url = "https://lilyterm.luna.com.tw/file/${pname}-${version}.tar.gz";
          sha256 = "0x2x59qsxq6d6xg5sd5lxbsbwsdvkwqlk17iw3h4amjg3m1jc9mp";
        };
      }
    else {
        version = "2019-07-25";
        src = fetchFromGitHub {
          owner = "Tetralet";
          repo = pname;
          rev = "faf1254f46049edfb1fd6e9191e78b1b23b9c51d";
          sha256 = "054450gk237c62b677365bcwrijr63gd9xm8pv68br371wdzylz7";
        };
      };

in
with stdenv.lib;
stdenv.mkDerivation rec {
  inherit pname;

  inherit (stuff) src version;

  nativeBuildInputs = [ pkgconfig autoconf automake intltool gettext ];
  buildInputs = [ gtk vte ];

  preConfigure = "sh autogen.sh";

  configureFlags = [
    "--enable-nls"
    "--enable-safe-mode"
  ];

  meta = with stdenv.lib; {
    description = "A fast, lightweight terminal emulator";
    longDescription = ''
      LilyTerm is a terminal emulator based off of libvte that aims to be fast and lightweight.
    '';
    homepage = https://lilyterm.luna.com.tw/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres Profpatsch ];
    platforms = platforms.linux;
  };
}
