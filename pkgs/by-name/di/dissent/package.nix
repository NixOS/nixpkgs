{
  buildGoModule,
  fetchFromGitHub,
  gobject-introspection,
  gst_all_1,
  lib,
  libadwaita,
  libcanberra-gtk3,
  pkg-config,
  sound-theme-freedesktop,
  wrapGAppsHook4,
}:

buildGoModule rec {
  pname = "dissent";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "dissent";
    rev = "v${version}";
    hash = "sha256-ysI7zgducK52XbSzsaCnffSC9BRd/aaybMif/GkkhcI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    # Optional according to upstream but required for sound and video
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    libadwaita
    libcanberra-gtk3
    sound-theme-freedesktop
  ];

  postInstall = ''
    install -D -m 444 -t $out/share/applications nix/so.libdb.dissent.desktop
    install -D -m 444 -t $out/share/icons/hicolor/scalable/apps internal/icons/hicolor/scalable/apps/so.libdb.dissent.svg
    install -D -m 444 -t $out/share/icons/hicolor/symbolic/apps internal/icons/symbolic/apps/so.libdb.dissent-symbolic.svg
    install -D -m 444 -t $out/share/metainfo so.libdb.dissent.metainfo.xml
    install -D -m 444 -t $out/share/dbus-1/services nix/so.libdb.dissent.service
  '';

  vendorHash = "sha256-qBgj3h+WKWxVahRXyO/w2zGY4UCVkjP7XKFk/9GOFqs=";

  meta = with lib; {
    description = "A third-party Discord client designed for a smooth, native experience (formerly gtkcord4)";
    homepage = "https://github.com/diamondburned/dissent";
    license = with licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "dissent";
    maintainers = with maintainers; [
      hmenke
      urandom
      aleksana
    ];
  };
}
