{
  buildGoModule,
  fetchFromGitLab,
  fetchFromGitHub,
  gobject-introspection,
  gst_all_1,
  lib,
  libadwaita,
  libcanberra-gtk3,
  pkg-config,
  sound-theme-freedesktop,
  libspelling,
  gtksourceview5,
  wrapGAppsHook4,
}:

let
  libspelling_2_1 = libspelling.overrideAttrs {
    version = "0.2.1";

    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libspelling";
      rev = "refs/tags/0.2.1";
      hash = "sha256-0OGcwPGWtYYf0XmvzXEaQgebBOW/6JWcDuF4MlQjCZQ=";
    };
  };
in
buildGoModule rec {
  pname = "dissent";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "dissent";
    rev = "v${version}";
    hash = "sha256-mI0rZ7w2a6fzELYRHgeekTWYDaQGcDYectRWUdOmlYc=";
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
    # gotk4-spelling fails to build with libspelling >= 0.3.0
    # https://github.com/diamondburned/gotk4-spelling/issues/1
    libspelling_2_1
    gtksourceview5
  ];

  postInstall = ''
    substituteInPlace nix/so.libdb.dissent.service \
      --replace-warn "/usr/bin/dissent" "$out/bin/dissent"
    install -D -m 444 -t $out/share/applications nix/so.libdb.dissent.desktop
    install -D -m 444 -t $out/share/icons/hicolor/scalable/apps internal/icons/hicolor/scalable/apps/so.libdb.dissent.svg
    install -D -m 444 -t $out/share/icons/hicolor/symbolic/apps internal/icons/symbolic/apps/so.libdb.dissent-symbolic.svg
    install -D -m 444 -t $out/share/metainfo so.libdb.dissent.metainfo.xml
    install -D -m 444 -t $out/share/dbus-1/services nix/so.libdb.dissent.service
  '';

  vendorHash = "sha256-JISIS8k/veBAqZ0DlxVBrc+25IVM6BpY4eE5uxsjo+Y=";

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
