{ stdenv, lib, fetchurl, pkgconfig, pcre, perl, flex, bison, gettext, libpcap, libnl, c-ares
, gnutls, libgcrypt, libgpgerror, geoip, openssl, lua5, makeDesktopItem, python, libcap, glib
, libssh, zlib, cmake, extra-cmake-modules, fetchpatch
, withGtk ? false, gtk3 ? null, librsvg ? null, gsettings_desktop_schemas ? null, wrapGAppsHook ? null
, withQt ? false, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withGtk -> !withQt  && gtk3 != null;
assert withQt  -> !withGtk && qt5  != null;

with stdenv.lib;

let
  version = "2.4.0";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";

in stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "http://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.xz";
    sha256 = "011vvrj76z1azkpvyy2j40b1x1z56ymld508zfc4xw3gh8dv82w9";
  };

  cmakeFlags = optional withGtk "-DBUILD_wireshark_gtk=TRUE";

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

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch

              # Backported from master. Will probably have to be dropped during next
              # update.
              (fetchpatch {
                 name = "AUTHORS_add_newline_after_bracket";
                 url = "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=patch;h=27c6b12626d6e7b8e4d7a11784c2c5e2bfb87fde";
                 sha256 = "1x30rkrq7dzgdlwrjv2r5ibdpdgwnn5wzvki77rdf13b0547vcw3";
               })
              # A file is missing from distribution. This should be fixed in upcoming
              # releases
              ./add_missing_udpdump_pod.patch
            ];

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
      experts. It runs on UNIX, OS X and Windows.
    '';

    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
