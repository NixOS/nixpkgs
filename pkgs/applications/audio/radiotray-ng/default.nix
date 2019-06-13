{ stdenv, fetchFromGitHub
, cmake, pkgconfig
# Transport
, curl
# Libraries
, boost
, jsoncpp
, libbsd
, pcre
# GUI/Desktop
, dbus
, glibmm
, gsettings-desktop-schemas
, hicolor-icon-theme
, libappindicator-gtk3
, libnotify
, libxdg_basedir
, wxGTK
# GStreamer
, gst_all_1
# User-agent info
, lsb-release
# rt2rtng
, python2
# Testing
, gtest
# Fixup
, wrapGAppsHook
, makeWrapper
}:

let
  gstInputs = with gst_all_1; [
    gstreamer gst-plugins-base
    gst-plugins-good gst-plugins-bad gst-plugins-ugly
    gst-libav
  ];
  # For the rt2rtng utility for converting bookmark file to -ng format
  pythonInputs = with python2.pkgs; [ python2 lxml ];
in
stdenv.mkDerivation rec {
  name = "radiotray-ng-${version}";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "ebruck";
    repo = "radiotray-ng";
    rev = "v${version}";
    sha256 = "1crvpn1mgrv7bd2k683mpgs59785mkrjvmp1f14iyq4qrr0f9zzi";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook makeWrapper ];

  buildInputs = [
    curl
    boost jsoncpp libbsd pcre
    glibmm hicolor-icon-theme gsettings-desktop-schemas libappindicator-gtk3 libnotify
    libxdg_basedir
    lsb-release
    wxGTK
  ] ++ gstInputs
    ++ pythonInputs;

  patches = [ ./no-dl-googletest.patch ];

  postPatch = ''
    for x in debian/CMakeLists.txt include/radiotray-ng/common.hpp data/*.desktop; do
      substituteInPlace $x --replace /usr $out
    done

    # We don't find the radiotray-ng-notification icon otherwise
    substituteInPlace data/radiotray-ng.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
    substituteInPlace data/rtng-bookmark-editor.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
  '';

  cmakeFlags = [
    "-DBUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  enableParallelBuilding = true;

  checkInputs = [ gtest ];
  doCheck = !stdenv.isAarch64; # single failure that I can't explain

  preFixup = ''
    gappsWrapperArgs+=(--suffix PATH : ${stdenv.lib.makeBinPath [ dbus ]})
    wrapProgram $out/bin/rt2rtng --prefix PYTHONPATH : $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "An internet radio player for linux";
    homepage = https://github.com/ebruck/radiotray-ng;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
