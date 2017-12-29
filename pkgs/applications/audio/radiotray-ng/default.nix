{ stdenv, fetchFromGitHub, fetchpatch
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
, gnome3
, hicolor_icon_theme
, libappindicator-gtk3
, libnotify
, libxdg_basedir
# GStreamer
, gst_all_1
# User-agent info
, lsb-release
# rt2rtng
, python2
# Testing
, gmock
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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "ebruck";
    repo = "radiotray-ng";
    rev = "v${version}";
    sha256 = "1m853gzh9r249crn0xyrq22x154r005j58b0kq3nsrgi5cps2zdv";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook makeWrapper ];

  buildInputs = [
    curl
    boost jsoncpp libbsd pcre
    glibmm hicolor_icon_theme gnome3.gsettings_desktop_schemas libappindicator-gtk3 libnotify
    libxdg_basedir
    lsb-release
  ] ++ stdenv.lib.optional doCheck gmock
    ++ gstInputs
    ++ pythonInputs;

  prePatch = ''
    substituteInPlace debian/CMakeLists.txt \
      --replace /usr $out
    substituteInPlace include/radiotray-ng/common.hpp \
      --replace /usr $out
  '';

  patches = [
    (fetchpatch {
      # Fix menu separators and minor touchup to 'version'
      url = "https://github.com/ebruck/radiotray-ng/commit/827e9f1baaa03ab4d8a5fb3aab043e72950eb965.patch";
      sha256 = "1aykl6lq4pga34xg5r9mc616gxnd63q6gr8qzg57w6874cj3csrr";
    })
  ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = "ctest";

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
