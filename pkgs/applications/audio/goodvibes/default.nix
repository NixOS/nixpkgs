{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, gtk3
, libsoup
, keybinder3
, gst_all_1
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "goodvibes";
  version = "0.7.7";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7AhdygNl6st5ryaMjrloBvTVz6PN48Y6VVpde5g3+D4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    libsoup
    keybinder3
  ] ++ (with gst_all_1; [
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
    description = "A lightweight internet radio player";
    homepage = "https://gitlab.com/goodvibes/goodvibes";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
