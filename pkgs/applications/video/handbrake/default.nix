# Upstream distributes HandBrake with bundle of according versions of libraries and patches to them.
#
# Derivation patches HandBrake to use Nix closure dependencies.
#

{ stdenv, lib, fetchurl,
  # Main build tools
  python2, pkgconfig, autoconf, automake, cmake, nasm, libtool, m4,
  # Processing, video codecs, containers
  ffmpeg-full, nv-codec-headers, libogg, x264, x265, libvpx, libtheora,
  # Codecs, audio
  libopus, lame, libvorbis, a52dec, speex, libsamplerate,
  # Text processing
  libiconv, fribidi, fontconfig, freetype, libass, jansson, libxml2,
  # Optical media
  libdvdread, libdvdnav, libdvdcss, libbluray,
  useGtk ? true, wrapGAppsHook ? null,
                 intltool ? null,
                 glib ? null,
                 gtk3 ? null,
                 libappindicator-gtk3 ? null,
                 libnotify ? null,
                 gst_all_1 ? null,
                 dbus-glib ? null,
                 udev ? null,
                 libgudev ? null,
                 hicolor-icon-theme ? null,
  useFdk ? false, fdk_aac ? null
}:

stdenv.mkDerivation rec {
  pname = "handbrake";
  version = "1.2.2";

  src = fetchurl {
    url = ''https://download2.handbrake.fr/${version}/HandBrake-${version}-source.tar.bz2'';
    sha256 = "0k2yaqy7zi06k8mkp9az2mn9dlgj3a1339vacakfh2nn2zsics6z";
  };

  nativeBuildInputs = [
    python2 pkgconfig autoconf automake cmake nasm libtool m4
  ] ++ lib.optionals useGtk [ intltool wrapGAppsHook ];

  buildInputs = [
    ffmpeg-full libogg libtheora x264 x265 libvpx
    libopus lame libvorbis a52dec speex libsamplerate
    libiconv fribidi fontconfig freetype libass jansson libxml2
    libdvdread libdvdnav libdvdcss libbluray
  ] ++ lib.optionals useGtk [
    glib gtk3 libappindicator-gtk3 libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus-glib udev
    libgudev hicolor-icon-theme
  ] ++ lib.optional useFdk fdk_aac
  # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
  # look at ./make/configure.py search "enable_nvenc"
    ++ lib.optional stdenv.isLinux nv-codec-headers;

  # NOTE: 2018-12-25: v1.2.0 now requires cmake dep
  # (default distribution bundles&builds 3rd party libs),
  # don't trigger cmake build
  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs scripts

    substituteInPlace libhb/module.defs \
      --replace /usr/include/libxml2 ${libxml2.dev}/include/libxml2

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -i '/PKG_CONFIG_PATH=/d' gtk/module.rules
  '';

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
    (if useGtk then "--disable-gtk-update-checks" else "--disable-gtk")
    (if useFdk then "--enable-fdk-aac"            else "")
  ];

  # NOTE: 2018-12-27: Check NixOS HandBrake test if changing
  NIX_LDFLAGS = [
    "-lx265"
  ];

  preBuild = ''
    cd build
  '';

  meta = with stdenv.lib; {
    homepage = http://handbrake.fr/;
    description = "A tool for converting video files and ripping DVDs";
    longDescription = ''
      Tool for converting and remuxing video files
      into selection of modern and widely supported codecs
      and containers. Very versatile and customizable.
      Package provides:
      CLI - `HandbrakeCLI`
      GTK+ GUI - `ghb`
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ Anton-Latukha wmertens ];
    platforms = with platforms; unix;
  };
}
