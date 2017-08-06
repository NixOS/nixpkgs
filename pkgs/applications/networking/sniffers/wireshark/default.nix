{ stdenv, lib, fetchurl, pkgconfig, pcre, perl, flex, bison, gettext, libpcap, libnl, c-ares
, gnutls, libgcrypt, libgpgerror, geoip, openssl, lua5, makeDesktopItem, python, libcap, glib
, libssh, zlib, cmake, extra-cmake-modules
, withGtk ? false, gtk3 ? null, librsvg ? null, gsettings_desktop_schemas ? null, wrapGAppsHook ? null
, withQt ? false, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withGtk -> !withQt  && gtk3 != null;
assert withQt  -> !withGtk && qt5  != null;

with stdenv.lib;

let
  version = "2.2.7";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";

in stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "http://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.bz2";
    sha256 = "1dfvhra5v6xhzbp097qsxi0zvirw0srbasl4v1wjf58v49idz7b8";
  };

  nativeBuildInputs = [
    bison cmake extra-cmake-modules flex
  ] ++ optional withGtk wrapGAppsHook;

  buildInputs = [
    gettext pcre perl pkgconfig libpcap lua5 libssh openssl libgcrypt
    libgpgerror gnutls geoip c-ares python glib zlib
  ] ++ optionals withQt  (with qt5; [ qtbase qtmultimedia qtsvg qttools ])
    ++ optionals withGtk [ gtk3 librsvg gsettings_desktop_schemas ]
    ++ optionals stdenv.isLinux  [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ];

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ];

  postInstall = optionalString (withQt || withGtk) ''
    ${optionalString withGtk ''
      install -Dm644 -t $out/share/applications ../wireshark-gtk.desktop
    ''}
    ${optionalString withQt ''
      install -Dm644 -t $out/share/applications ../wireshark.desktop
    ''}

    substituteInPlace $out/share/applications/*.desktop \
      --replace "Exec=wireshark" "Exec=$out/bin/wireshark"

    install -Dm644 ../image/wsicon.svg $out/share/icons/wireshark.svg
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.wireshark.org/;
    description = "Powerful network protocol analyzer";
    license = licenses.gpl2;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';

    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
