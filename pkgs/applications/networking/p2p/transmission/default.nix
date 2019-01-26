{ stdenv, fetchurl, pkgconfig, intltool, file, wrapGAppsHook
, openssl, curl, libevent, inotify-tools, systemd, zlib, hicolor-icon-theme
, enableGTK3 ? false, gtk3
, enableSystemd ? stdenv.isLinux
, enableDaemon ? true
, enableCli ? true
}:

let inherit (stdenv.lib) optional optionals optionalString; in

stdenv.mkDerivation rec {
  name = "transmission-" + optionalString enableGTK3 "gtk-" + version;
  version = "2.94";

  src = fetchurl {
    url = "https://github.com/transmission/transmission-releases/raw/master/transmission-2.94.tar.xz";
    sha256 = "0zbbj7rlm6m7vb64x68a64cwmijhsrwx9l63hbwqs7zr9742qi1m";
  };

  nativeBuildInputs = [ pkgconfig ]
    ++ optionals enableGTK3 [ wrapGAppsHook ];
  buildInputs = [ intltool file openssl curl libevent zlib ]
    ++ optionals enableGTK3 [ gtk3 ]
    ++ optionals enableSystemd [ systemd ]
    ++ optionals stdenv.isLinux [ inotify-tools ]
    ++ optionals enableGTK3 [ hicolor-icon-theme ];

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

