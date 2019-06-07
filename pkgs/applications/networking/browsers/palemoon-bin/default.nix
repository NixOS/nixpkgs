{ stdenv, fetchurl }:

let
  palemoonPlatforms = {
    "i686-linux" = "linux-i686";
    "x86_64-linux" = "linux-x86_64";
  };

  arch = palemoonPlatforms.${stdenv.hostPlatform.system};

in

stdenv.mkDerivation rec {
  name = "palemoon-bin-${version}";
  version = "28.5.2";

  src = fetchurl {
    url = "https://linux.palemoon.org/datastore/release/palemoon-${version}.${arch}.tar.bz2";
    sha256 = "0r1vl2z4dd47d454ba7k7748x6bir1l23wbivjrbxvmiwar5z1ak";
  };
  outputs = [ "out" "orig" ];
  sourceRoot = ".";
  unpackCmd = ''
    cat "$src" | tar xj
  '';

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/bin $orig
    cp -R palemoon/* $orig/
    ln -s $orig/palemoon $out/bin/palemoon
    __desktop_icon="[Desktop Entry]
Version=1.0
Name=Pale Moon Web Browser
Comment=Browse the World Wide Web
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=$orig/palemoon %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=palemoon
Categories=Network;WebBrowser;Internet
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true"
    echo "$__desktop_icon" > $orig/palemoon.desktop
    chmod a+x $orig/palemoon.desktop
  '';

  meta = with stdenv.lib; {
    description = "Goanna-based web browser";
    longDescription = ''
      Pale Moon is an Open Source, Goanna-based web browser focusing on
      efficiency and customization.

      Pale Moon offers you a browsing experience in a browser completely built
      from its own, independently developed source that has been forked off from
      Firefox/Mozilla code a number of years ago, with carefully selected
      features and optimizations to improve the browser's stability and user
      experience, while offering full customization and a growing collection of
      extensions and themes to make the browser truly your own.
    '';
    homepage = https://www.palemoon.org/;
    license = {
      free = false;
      url = https://www.palemoon.org/licensing.shtml;
    };
    maintainers = with maintainers; [ rnhmjoj AndersonTorres ];
    platforms = platforms.linux;
  };
}
