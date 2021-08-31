{ lib, stdenv, fetchFromGitHub
, desktop-file-utils, glib, gtk3, meson, ninja, pkg-config, python3, vala
, wrapGAppsHook
, glib-networking, gobject-introspection, json-glib, libgee, libhandy, libsoup
}:

stdenv.mkDerivation rec {
  pname = "markets";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "bitstower";
    repo = "markets";
    rev = version;
    sha256 = "0nk1bs7i6b7r90g5qwd3s2m462vk3kvza0drq7rzb5sdaiz9ccnz";
  };

  nativeBuildInputs = [
    desktop-file-utils glib gtk3 meson ninja pkg-config python3 vala
    wrapGAppsHook
  ];
  buildInputs = [
    glib glib-networking gobject-introspection gtk3 json-glib libgee libhandy
    libsoup
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  postInstall = ''
    ln -s bitstower-markets $out/bin/markets
  '';

  meta = with lib; {
    homepage = "https://github.com/bitstower/markets";
    description = "Stock, currency and cryptocurrency tracker";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
