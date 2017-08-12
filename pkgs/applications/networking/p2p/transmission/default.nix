{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, file, wrapGAppsHook
, openssl, curl, libevent, inotify-tools, systemd, zlib
, enableGTK3 ? false, gtk3, hicolor_icon_theme
, enableSystemd ? stdenv.isLinux
, enableDaemon ? true
, enableCli ? true
}:

let
  version = "2.92";
in

let inherit (stdenv.lib) optional optionals optionalString; in

stdenv.mkDerivation rec {
  name = "transmission-" + optionalString enableGTK3 "gtk-" + version;

  src = fetchurl {
    url = "https://transmission.cachefly.net/transmission-${version}.tar.xz";
    sha256 = "0pykmhi7pdmzq47glbj8i2im6iarp4wnj4l1pyvsrnba61f0939s";
  };

  buildInputs = [ pkgconfig intltool file openssl curl libevent zlib ]
    ++ optionals enableGTK3 [ gtk3 wrapGAppsHook hicolor_icon_theme ]
    ++ optionals enableSystemd [ systemd ]
    ++ optionals stdenv.isLinux [ inotify-tools ];

  patches = [
    (fetchpatch {
      url = "https://github.com/transmission/transmission/commit/eb8f5004e01e054c7dd4f5b93e7c0a4daed957f4.patch";
      sha256 = "0kxyzd5b9p6bjznp5mh87108bc8h3mn3n4fyp8brcqvxm7c527xv";
    })
  ];

  postPatch = ''
    substituteInPlace ./configure \
      --replace "libsystemd-daemon" "libsystemd" \
      --replace "/usr/bin/file"     "${file}/bin/file" \
      --replace "test ! -d /Developer/SDKs/MacOSX10.5.sdk" "false"
  '';

  configureFlags = [
      ("--enable-cli=" + (if enableCli then "yes" else "no"))
      ("--enable-daemon=" + (if enableDaemon then "yes" else "no"))
      "--disable-mac" # requires xcodebuild
    ]
    ++ optional enableSystemd "--with-systemd-daemon"
    ++ optional enableGTK3 "--with-gtk";

#  preFixup = optionalString enableGTK3 /* gsettings schemas for file dialogues */ ''
#    rm "$out/share/icons/hicolor/icon-theme.cache"
#  '';

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-framework CoreFoundation";

  meta = with stdenv.lib; {
    description = "A fast, easy and free BitTorrent client";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
      Feature spotlight:
        * Uses fewer resources than other clients
        * Native Mac, GTK+ and Qt GUI clients
        * Daemon ideal for servers, embedded systems, and headless use
        * All these can be remote controlled by Web and Terminal clients
        * Bluetack (PeerGuardian) blocklists with automatic updates
        * Full encryption, DHT, and PEX support
    '';
    homepage = http://www.transmissionbt.com/;
    license = licenses.gpl2; # parts are under MIT
    maintainers = with maintainers; [ astsmtl vcunat wizeman ];
    platforms = platforms.unix;
  };
}

