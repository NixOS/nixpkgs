{
  lib,
  fetchFromGitHub,
  glib,
  gst_all_1,
  iproute2,
  libtool,
  makeBinaryWrapper,
  meson,
  miraclecast,
  ninja,
  pkg-config,
  readline,
  stdenv,
  systemdLibs,
  testers,
  udev,
  wpa_supplicant,
  relyUdev ? true,
}:

let
  gstreamerPluginPaths = lib.concatMapStrings (pth: pth + "/lib/gstreamer-1.0:") [
    (lib.getLib gst_all_1.gstreamer)
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];
in
stdenv.mkDerivation {
  pname = "miraclecast";
  version = "1.0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "albfan";
    repo = "miraclecast";
    rev = "937747fd4de64a33bccf5adb73924c435ceb821b";
    hash = "sha256-y37+AOz8xYjtDk9ITxMB7UeWeMpDH+b6HQBczv+x5zo=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    iproute2
    libtool
    readline
    systemdLibs
    udev
    wpa_supplicant
  ];

  mesonFlags = [
    "-Dbuild-tests=true"
    "-Dip-binary=${iproute2}/bin/ip"
  ]
  ++ lib.optionals relyUdev [
    "-Drely-udev=true"
  ];

  postPatch = ''
    substituteInPlace res/miracle-gst \
      --replace-fail "/usr/bin/gst-launch-1.0" "${gst_all_1.gstreamer}/bin/gst-launch-1.0"
  '';

  postInstall = ''
    wrapProgram $out/bin/miracle-gst --set GST_PLUGIN_SYSTEM_PATH_1_0 ${gstreamerPluginPaths}
  '';

  passthru.tests.version = testers.testVersion {
    package = miraclecast;
    command = "miracled --version";
    version = "Miraclecast 1";
  };

  meta = with lib; {
    description = "Connect external monitors to your system via Wifi-Display specification also known as Miracast";
    homepage = "https://github.com/albfan/miraclecast";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.wizardlink ];
    platforms = platforms.linux;
  };
}
