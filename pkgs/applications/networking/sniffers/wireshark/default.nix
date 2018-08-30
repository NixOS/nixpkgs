{ stdenv, fetchurl, pkgconfig, pcre, perl, flex, bison, gettext, libpcap, libnl, c-ares
, gnutls, libgcrypt, libgpgerror, geoip, openssl, lua5, python, libcap, glib
, libssh, zlib, cmake, extra-cmake-modules, fetchpatch, makeWrapper
, withGtk ? false, gtk3 ? null, librsvg ? null, gsettings-desktop-schemas ? null, wrapGAppsHook ? null
, withQt ? false, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withGtk -> !withQt  && gtk3 != null;
assert withQt  -> !withGtk && qt5  != null;

with stdenv.lib;

let
  version = "2.6.2";
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";

in stdenv.mkDerivation {
  name = "wireshark-${variant}-${version}";

  src = fetchurl {
    url = "https://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.xz";
    sha256 = "153h6prxamv5a62f3pfadkry0y57696xrgxfy2gfy5xswdg8kcj9";
  };

  cmakeFlags = [
    "-DBUILD_wireshark_gtk=${if withGtk then "ON" else "OFF"}"
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    "-DENABLE_QT5=${if withQt then "ON" else "OFF"}"
    "-DENABLE_APPLICATION_BUNDLE=${if withQt && stdenv.isDarwin then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    bison cmake extra-cmake-modules flex pkgconfig
  ] ++ optional withGtk wrapGAppsHook;

  buildInputs = [
    gettext pcre perl libpcap lua5 libssh openssl libgcrypt
    libgpgerror gnutls geoip c-ares python glib zlib makeWrapper
  ] ++ optionals withQt  (with qt5; [ qtbase qtmultimedia qtsvg qttools ])
    ++ optionals withGtk [ gtk3 librsvg gsettings-desktop-schemas ]
    ++ optionals stdenv.isLinux  [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ]
    ++ optionals (withQt && stdenv.isDarwin) (with qt5; [ qtmacextras ]);

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ]
    # https://code.wireshark.org/review/#/c/23728/
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "fix-timeout.patch";
      url = "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=commitdiff_plain;h=8b5b843fcbc3e03e0fc45f3caf8cf5fc477e8613;hp=94af9724d140fd132896b650d10c4d060788e4f0";
      sha256 = "1g2dm7lwsnanwp68b9xr9swspx7hfj4v3z44sz3yrfmynygk8zlv";
    });

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  preBuild = ''
    export LD_LIBRARY_PATH="$PWD/run"
  '';

  postInstall = if stdenv.isDarwin then ''
    ${optionalString withQt ''
      mkdir -p $out/Applications
      mv $out/bin/Wireshark.app $out/Applications/Wireshark.app

      for so in $out/Applications/Wireshark.app/Contents/PlugIns/wireshark/*.so; do
        install_name_tool $so -change libwireshark.10.dylib $out/lib/libwireshark.10.dylib
        install_name_tool $so -change libwiretap.7.dylib $out/lib/libwiretap.7.dylib
        install_name_tool $so -change libwsutil.8.dylib $out/lib/libwsutil.8.dylib
      done

      wrapProgram $out/Applications/Wireshark.app/Contents/MacOS/Wireshark \
        --set QT_PLUGIN_PATH ${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}
    ''}
  '' else optionalString (withQt || withGtk) ''
    ${optionalString withGtk ''
      install -Dm644 -t $out/share/applications ../wireshark-gtk.desktop
    ''}
    ${optionalString withQt ''
      install -Dm644 -t $out/share/applications ../wireshark.desktop
      wrapProgram $out/bin/wireshark \
        --set QT_PLUGIN_PATH ${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}
    ''}

    substituteInPlace $out/share/applications/*.desktop \
      --replace "Exec=wireshark" "Exec=$out/bin/wireshark"

    install -Dm644 ../image/wsicon.svg $out/share/icons/wireshark.svg
  '';

  enableParallelBuilding = true;

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  meta = with stdenv.lib; {
    homepage = https://www.wireshark.org/;
    description = "Powerful network protocol analyzer";
    license = licenses.gpl2;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
