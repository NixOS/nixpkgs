{ lib, stdenv, fetchFromGitHub, pkg-config, gtk2, lua, perl, python3Packages
, pciutils, dbus-glib, libcanberra-gtk2, libproxy
, enchant2, libnotify, openssl, isocodes
, desktop-file-utils
, meson, ninja, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "hexchat";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "hexchat";
    repo = "hexchat";
    rev = "v${version}";
    sha256 = "sha256-rgaXqXbBWlfSyz+CT0jRLyfGOR1cYYnRhEAu7AsaWus=";
  };

  nativeBuildInputs = [ meson ninja pkg-config makeWrapper ];

  buildInputs = [
    gtk2 lua perl python3Packages.python python3Packages.cffi pciutils dbus-glib libcanberra-gtk2 libproxy
    libnotify openssl desktop-file-utils
    isocodes
  ];

  #hexchat and hexchat-text loads enchant spell checking library at run time and so it needs to have route to the path
  postPatch = ''
    sed -i "s,libenchant-2.so.2,${enchant2}/lib/libenchant-2.so.2,g" src/fe-gtk/sexy-spell-entry.c
    sed -i "/flag.startswith('-I')/i if flag.contains('no-such-path')\ncontinue\nendif" plugins/perl/meson.build
    chmod +x meson_post_install.py
    for f in meson_post_install.py \
             plugins/perl/generate_header.py \
             plugins/python/generate_plugin.py \
             po/validate-textevent-translations \
             src/common/make-te.py
    do
      patchShebangs $f
    done
  '';

  mesonFlags = [ "-Dwith-lua=lua" "-Dtext-frontend=true" ];

  postInstall = ''
    wrapProgram $out/bin/hexchat --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with lib; {
    description = "A popular and easy to use graphical IRC (chat) client";
    homepage = "https://hexchat.github.io/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
