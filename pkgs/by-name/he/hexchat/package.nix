{
  dbus-glib,
  desktop-file-utils,
  enchant2,
  fetchFromGitHub,
  gtk2,
  isocodes,
  lib,
  libcanberra-gtk2,
  libnotify,
  libproxy,
  lua,
  makeWrapper,
  meson,
  ninja,
  openssl,
  pciutils,
  perl,
  pkg-config,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "hexchat";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "hexchat";
    repo = "hexchat";
    rev = "v${version}";
    hash = "sha256-rgaXqXbBWlfSyz+CT0jRLyfGOR1cYYnRhEAu7AsaWus=";
  };

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

  mesonFlags = [
    "-Dwith-lua=lua"
    "-Dtext-frontend=true"
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus-glib
    desktop-file-utils
    gtk2
    isocodes
    libcanberra-gtk2
    libnotify
    libproxy
    lua
    openssl
    pciutils
    perl
    python3Packages.cffi
    python3Packages.python
    python3Packages.setuptools
  ];

  postInstall = ''
    wrapProgram $out/bin/hexchat --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = {
    description = "Popular and easy to use graphical IRC (chat) client";
    homepage = "https://hexchat.github.io/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
