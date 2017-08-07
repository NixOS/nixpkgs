{ stdenv, fetchurl
, pkgconfig, cmake
, pulseaudio
, libmtp, taglib, zlib
, pcre
, qtbase, qttools
, gstreamer, gst-plugins-base, gst-plugins-bad, gst-plugins-ugly
, wrapGAppsHook }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "sayonara-player-${version}";
  version = "0.9.3-git2-20170509";

  src = fetchurl {
    url = "https://sayonara-player.com/sw/${name}.tar.gz";
    sha256 = "1x8lbh7v9nppbaizqv03vgnnmpx916q0ifna6ym874ixgv7wc4h4";
  };

  nativeBuildInputs = [ pkgconfig cmake wrapGAppsHook ];

  buildInputs = [ qtbase qttools
    pcre libmtp
    taglib zlib gstreamer gst-plugins-base gst-plugins-bad gst-plugins-ugly ];

   preConfigure = ''
     export NIX_CFLAGS_COMPILE="-I${gst-plugins-base.dev}/include/gstreamer-1.0 $NIX_CFLAGS_COMPILE"
   '';

   # TODO: alert upstream developers about it
   preBuild = ''
     sed -i -e 's|/var/empty/share|$out/share|' src/GUI/Resources/Icons/cmake_install.cmake
   '';

   meta = with stdenv.lib;{
    homapege = "https://sayonara-player.com/";
    description = "A lightweight audio player, written in C++ and using Qt5 and Gstreamer";
    longDescription = ''
       Sayonara is a small, clear and fast audio player for Linux written in
       C++, supported by the Qt framework. It uses Gstreamer as audio backend.

       Although Sayonara is considered as a lightweight player, it holds a lot
       of features to organize even big music collections.

       Most of them are known from the bigger and well known audio players. But
       in contrast to most of the other players the main focus during developing
       has been performance, low CPU usage and low memory consumption.

       So Sayonara is a good alternative to players like Rhythmbox, Clementine
       or Amarok. Those who miss Winamp for Linux should give Sayonara a try.
       One of Sayonara's goals is intuitive and easy usablility. Currently it 
       is only available for Linux.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
