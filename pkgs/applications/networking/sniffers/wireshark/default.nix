{ stdenv, lib, fetchurl, pkgconfig, pcre, perl, flex, bison, gettext, libpcap, libnl, c-ares
, gnutls, libgcrypt, libgpgerror, geoip, openssl, lua5, makeDesktopItem, python, libcap, glib
, libssh, zlib, cmake, extra-cmake-modules, fetchpatch
, withGtk ? false, gtk3 ? null, librsvg ? null, gsettings-desktop-schemas ? null, wrapGAppsHook ? null
, withQt ? false, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withGtk -> !withQt  && gtk3 != null;
assert withQt  -> !withGtk && qt5  != null;

with stdenv.lib;

let
  version = "2.4.4";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";

in stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "http://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.xz";
    sha256 = "0n3g28hrhifnchlz4av0blq4ykm4zaxwwxbzdm9wsba27677b6h4";
  };

  cmakeFlags = [
    "-DBUILD_wireshark_gtk=${if withGtk then "ON" else "OFF"}"
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    bison cmake extra-cmake-modules flex pkgconfig
  ] ++ optional withGtk wrapGAppsHook;

  buildInputs = [
    gettext pcre perl libpcap lua5 libssh openssl libgcrypt
    libgpgerror gnutls geoip c-ares python glib zlib
  ] ++ optionals withQt  (with qt5; [ qtbase qtmultimedia qtsvg qttools ])
    ++ optionals withGtk [ gtk3 librsvg gsettings-desktop-schemas ]
    ++ optionals stdenv.isLinux  [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ];

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ]
    # https://code.wireshark.org/review/#/c/23728/
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "fix-timeout.patch";
      url = "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=commitdiff_plain;h=8b5b843fcbc3e03e0fc45f3caf8cf5fc477e8613;hp=94af9724d140fd132896b650d10c4d060788e4f0";
      sha256 = "1g2dm7lwsnanwp68b9xr9swspx7hfj4v3z44sz3yrfmynygk8zlv";
    });

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

    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
