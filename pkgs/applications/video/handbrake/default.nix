# Upstream distributes HandBrake with bundle of according versions of libraries and patches to them.
#
# Derivation patches HandBrake to use our closure.
#

{ stdenv, lib, fetchurl,
  python2, pkgconfig, yasm, zlib,
  autoconf, automake, libtool, m4, jansson,
  libass, libiconv, libsamplerate, fribidi, libxml2, bzip2,
  libogg, libopus, libtheora, libvorbis, libdvdcss, a52dec,
  lame, libdvdread, libdvdnav, libbluray,
  mp4v2, mpeg2dec, x264, x265, libmkv,
  fontconfig, freetype, hicolor-icon-theme,
  glib, gtk3, intltool, libnotify,
  gst_all_1, dbus-glib, udev, libgudev, libvpx,
  useGtk ? true, wrapGAppsHook ? null, libappindicator-gtk3 ? null,
  useFfmpeg ? false, libav_12 ? null, ffmpeg ? null,
  useFdk ? false, fdk_aac ? null
}:

stdenv.mkDerivation rec {
  # TODO: Release 1.2.0 would switch LibAV to FFmpeg.
  version = "1.1.0";
  name = "handbrake-${version}";

  src = fetchurl {
    url = ''https://download2.handbrake.fr/${version}/HandBrake-${version}-source.tar.bz2'';
    sha256 = "1nj0ihflisxcfkmsk7fm3b5cn7cpnpg66dk2lkp2ip6qidppqbm0";
  };

  patched_libav_12 = libav_12.overrideAttrs (super: {
    # NOTE: 2018-04-26: HandBrake compilation (1.1.0) requires a patch of LibAV (12.3) from HandBrake team. This patch not went LibAV upstream.
    patches = (super.patches or []) ++ [(
      fetchurl {
        url = ''https://raw.githubusercontent.com/HandBrake/HandBrake/9e1f245708a157231c427c0ef9b91729d59a30e1/contrib/ffmpeg/A21-mp4-sdtp.patch'';
        sha256 = "14grzyvb1qbb90k31ibabnwmwnrc48ml6h2z0rjamdv83q45jq4g";
      })
    ];
  });

  nativeBuildInputs = [
    python2 pkgconfig yasm autoconf automake libtool m4
  ] ++ lib.optionals useGtk [ intltool wrapGAppsHook ];

  buildInputs = [
    fribidi fontconfig freetype jansson zlib
    libass libiconv libsamplerate libxml2 bzip2
    libogg libopus libtheora libvorbis libdvdcss a52dec libmkv
    lame libdvdread libdvdnav libbluray mp4v2 mpeg2dec x264 x265 libvpx
  ] ++ lib.optionals useGtk [
    glib gtk3 libappindicator-gtk3 libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus-glib udev
    libgudev hicolor-icon-theme
  ] ++ (if useFfmpeg then [ ffmpeg ] else [ patched_libav_12 ])
  ++ lib.optional useFdk fdk_aac;

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
