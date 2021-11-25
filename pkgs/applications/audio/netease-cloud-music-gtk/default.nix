{ lib
, stdenv
, glib
, gtk3
, curl
, dbus
, openssl
, gst_all_1
, pkg-config
, rustPlatform
, wrapGAppsHook
, fetchurl
, fetchFromGitHub
, makeDesktopItem
}:
rustPlatform.buildRustPackage rec {
  pname = "netease-cloud-music-gtk";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "gmg137";
    repo = "netease-cloud-music-gtk";
    rev = version;
    sha256 = "sha256-42MaylfG5LY+TiYHWQMoh9CiVLShKXSBpMrxdWhujow=";
  };
  cargoSha256 = "sha256-A9wIcESdaJwLY4g/QlOxMU5PBB9wjvIzaXBSqeiRJBM=";
  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [
    glib
    gtk3
    dbus
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    curl
    dbus
    openssl
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  postPatch = ''
    install -D netease-cloud-music-gtk.desktop $out/share/applications/netease-cloud-music-gtk.desktop
    install -D icons/netease-cloud-music-gtk.svg $out/share/icons/hicolor/scalable/apps/netease-cloud-music-gtk.svg
  '';

  meta = with lib; {
    description = "netease-cloud-music-gtk is a Rust + GTK based netease cloud music player";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ diffumist ];
  };
}
