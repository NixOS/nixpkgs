{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  glib-networking,
  gtk3,
  libsoup_3,
  keybinder3,
  gst_all_1,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "goodvibes";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zqJbtCqdwKXy13WWoAwSRYVhAOJsHqOF0DriSDEigbI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    appstream-glib
    desktop-file-utils
  ];

  buildInputs =
    [
      glib
      # for libsoup TLS support
      glib-networking
      gtk3
      libsoup_3
      keybinder3
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ]);

  postPatch = ''
    patchShebangs scripts
  '';

  meta = with lib; {
    description = "Lightweight internet radio player";
    homepage = "https://gitlab.com/goodvibes/goodvibes";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
