{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KflLEc6BFA3pBY9HukEm5NluGi2igFNP6joOMdmZ0Ds=";
  };
  patches = [
    # Fixes a compilation error
    (fetchpatch {
      url = "https://gitlab.com/goodvibes/goodvibes/-/commit/e332f831b91ee068a1a58846d7607b30ab010116.patch";
      hash = "sha256-PzbTltbD0xWJAytCGg1TAwBLrICP+9QZbCbG1QQ8Qmw=";
    })
  ];

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
