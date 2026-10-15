{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,

  # buildInputs
  bashNonInteractive,
  coreutils,
  glib,
  gst_all_1,
  gtk3,
  iproute2,
  procps,
  python3,
  readline,
  systemdLibs,
  wpa_supplicant,

  # checkInputs
  check,

  relyUdev ? true,
}:
let
  pythonPath = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation {
  pname = "miraclecast";
  version = "1.0-unstable-2026-03-10";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "albfan";
    repo = "miraclecast";
    rev = "0b7f1f1f6586dc65ff480f3cda5c2170a70aa020";
    hash = "sha256-AC4cFFjmUS3Ykshk4VHqnmZ5ak6jgQJSYQ6T3nM5NjE=";
  };

  postPatch = ''
    substituteInPlace res/gstplayer \
      --replace-fail 'GObject.threads_init()' ""
    substituteInPlace res/meson.build \
      --replace-fail \
        "join_paths(get_option('sysconfdir'), 'dbus-1', 'system.d')" \
        "join_paths(get_option('datadir'), 'dbus-1', 'system.d')"
    substituteInPlace res/miracle-gst \
      --replace-fail \
        '/usr/bin/gst-launch-1.0' \
        '${lib.getExe' gst_all_1.gstreamer "gst-launch-1.0"}'
    substituteInPlace res/uibc-viewer \
      --replace-fail 'ps -o' '${lib.getExe' procps "ps"} -o' \
      --replace-fail 'gstplayer $@' "$out/bin/gstplayer \$@" \
      --replace-fail '| miracle-uibcctl' "| $out/bin/miracle-uibcctl"
    substituteInPlace src/ctl/sinkctl.c \
      --replace-fail '"uibc-viewer"' "\"$out/bin/uibc-viewer\"" \
      --replace-fail '"miracle-gst"' "\"$out/bin/miracle-gst\"" \
      --replace-fail '"miracle-uibcctl"' "\"$out/bin/miracle-uibcctl\""
    substituteInPlace src/wifi/wifid-supplicant.c \
      --replace-fail '"miracle-dhcp"' "\"$out/bin/miracle-dhcp\""
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    bashNonInteractive
    glib
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    pythonPath
    readline
    systemdLibs
  ];

  mesonFlags = [
    (lib.mesonOption "ip-binary" (lib.getExe' iproute2 "ip"))
    (lib.mesonBool "rely-udev" relyUdev)
  ];

  doCheck = true;
  checkInputs = [ check ];
  mesonCheckFlags = [ "--exclude=Miraclecast:rtsp test" ];

  dontWrapGApps = true;

  postFixup = ''
    wrapGApp $out/bin/gstplayer
    wrapGApp $out/bin/miracle-gst \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
    wrapProgram $out/bin/miracle-wifid \
      --suffix PATH : ${lib.makeBinPath [ wpa_supplicant ]}
  '';

  meta = {
    description = "Connect external monitors to your system via Wifi-Display specification also known as Miracast";
    homepage = "https://github.com/albfan/miraclecast";
    license = with lib.licenses; [
      lgpl21Plus

      # src/dhcp
      gpl2Only
    ];
    maintainers = [ lib.maintainers.wizardlink ];
    platforms = lib.platforms.linux;
  };
}
