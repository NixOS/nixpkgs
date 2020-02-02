{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, gtk2, lua, perl, python3
, pciutils, dbus-glib, libcanberra-gtk2, libproxy
, enchant2, libnotify, openssl, isocodes
, desktop-file-utils
, meson, ninja
}:

stdenv.mkDerivation rec {
  pname = "hexchat";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "hexchat";
    repo = "hexchat";
    rev = "v${version}";
    sha256 = "08kvp0dcn3bvmlqcfp9312075bwkqkpa8m7zybr88pfp210gfl85";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    gtk2 lua perl python3 pciutils dbus-glib libcanberra-gtk2 libproxy
    libnotify openssl desktop-file-utils
    isocodes
  ];

  #hexchat and hexchat-text loads enchant spell checking library at run time and so it needs to have route to the path
  postPatch = ''
    sed -i "s,libenchant-2.so.2,${enchant2}/lib/libenchant-2.so.2,g" src/fe-gtk/sexy-spell-entry.c
    sed -i "/flag.startswith('-I')/i if flag.contains('no-such-path')\ncontinue\nendif" plugins/perl/meson.build
    chmod +x meson_post_install.py
    for f in meson_post_install.py \
             src/common/make-te.py \
             plugins/perl/generate_header.py \
             po/validate-textevent-translations
    do
      patchShebangs $f
    done
  '';

  mesonFlags = [ "-Dwith-lua=lua" "-Dwith-text=true" ];

  meta = with stdenv.lib; {
    description = "A popular and easy to use graphical IRC (chat) client";
    homepage = https://hexchat.github.io/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
