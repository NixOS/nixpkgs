{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  # Transport
  curl,
  # Libraries
  boost,
  jsoncpp,
  libbsd,
  # GUI/Desktop
  dbus,
  glibmm,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
  libappindicator-gtk3,
  libnotify,
  libxdg_basedir,
  wxGTK,
  # GStreamer
  glib-networking,
  gst_all_1,
  # User-agent info
  lsb-release,
  # rt2rtng
  python3,
  # Testing
  gtest,
  # Fixup
  wrapGAppsHook3,
  makeWrapper,
}:

let
  gstInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];
  # For the rt2rtng utility for converting bookmark file to -ng format
  pythonInputs = with python3.pkgs; [
    python
    lxml
  ];
in
stdenv.mkDerivation rec {
  pname = "radiotray-ng";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "ebruck";
    repo = "radiotray-ng";
    tag = "v${version}";
    hash = "sha256-rRD/IfVnOxowr2mO2BB2hcHK5ByZSmTbcgYdULogYUs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    curl
    boost
    jsoncpp
    libbsd
    glibmm
    hicolor-icon-theme
    gsettings-desktop-schemas
    libappindicator-gtk3
    libnotify
    libxdg_basedir
    lsb-release
    wxGTK
    # for https gstreamer / libsoup
    glib-networking
  ]
  ++ gstInputs
  ++ pythonInputs;

  patches = [
    ./no-dl-googletest.patch
    ./tests-c++17.patch
  ];

  postPatch = ''
    for x in package/CMakeLists.txt include/radiotray-ng/common.hpp data/*.desktop; do
      substituteInPlace $x --replace /usr $out
    done
    substituteInPlace package/CMakeLists.txt --replace /etc/xdg/autostart $out/etc/xdg/autostart

    # We don't find the radiotray-ng-notification icon otherwise
    substituteInPlace data/radiotray-ng.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
    substituteInPlace data/rtng-bookmark-editor.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
  '';

  cmakeFlags = [
    "-DBUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  # 'wxFont::wxFont(int, int, int, int, bool, const wxString&, wxFontEncoding)' is deprecated
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  nativeCheckInputs = [ gtest ];
  doCheck = !stdenv.hostPlatform.isAarch64; # single failure that I can't explain

  preFixup = ''
    gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ dbus ]})
    wrapProgram $out/bin/rt2rtng --prefix PYTHONPATH : $PYTHONPATH
  '';

  meta = {
    description = "Internet radio player for linux";
    homepage = "https://github.com/ebruck/radiotray-ng";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
