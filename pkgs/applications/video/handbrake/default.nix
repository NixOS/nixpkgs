# Handbrake normally uses its own copies of the libraries it uses, for better
# control over library patches.
#
# This derivation patches HB so it doesn't do that. The relevant patches
# are added to the Nix packages and proposed upstream instead. In several cases
# upstream already incorporated these patches.
# This has the benefits of providing improvements to other packages,
# making licenses more clear and reducing compile time/install size.
#
# Only tested on Linux
#
# TODO: package and use libappindicator

{ stdenv, config, fetchurl,
  python, pkgconfig, yasm,
  autoconf, automake, libtool, m4,
  libass, libsamplerate, fribidi, libxml2, bzip2,
  libogg, libtheora, libvorbis, libdvdcss, a52dec, fdk_aac,
  lame, ffmpeg, libdvdread, libdvdnav, libbluray,
  mp4v2, mpeg2dec, x264, x265, libmkv,
  fontconfig, freetype, hicolor_icon_theme,
  glib, gtk3, intltool, libnotify,
  gst_all_1, dbus_glib, udev, libgudev, libvpx,
  wrapGAppsHook,
  useGtk ? true
}:

stdenv.mkDerivation rec {
  version = "0.10.5";
  name = "handbrake-${version}";

  buildInputsX = stdenv.lib.optionals useGtk [
    glib gtk3 intltool libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus_glib udev
    libgudev
    wrapGAppsHook
  ];

  nativeBuildInputs = [ python pkgconfig yasm autoconf automake libtool m4 ];
  buildInputs = [
    fribidi fontconfig freetype hicolor_icon_theme
    libass libsamplerate libxml2 bzip2
    libogg libtheora libvorbis libdvdcss a52dec libmkv fdk_aac
    lame ffmpeg libdvdread libdvdnav libbluray mp4v2 mpeg2dec x264 x265 libvpx
  ] ++ buildInputsX;


  src = fetchurl {
    url = "http://download.handbrake.fr/releases/${version}/HandBrake-${version}.tar.bz2";
    sha256 = "1w720y3bplkz187wgvy4a4xm0vpppg45mlni55l6yi8v2bfk14pv";
  };

  preConfigure = ''
    # Fake wget to prevent downloads
    mkdir wget
    echo "#!/bin/sh" > wget/wget
    echo "echo ===== Not fetching \$*" >> wget/wget
    echo "exit 1" >> wget/wget
    chmod +x wget/wget
    export PATH=$PATH:$PWD/wget

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -i '/PKG_CONFIG_PATH=/d' gtk/module.rules

    patch -p1 -R < ${./handbrake-0.10.3-nolibav.patch}
  '';

  configureFlags = [
    "--enable-fdk-aac"
    (if useGtk then "--disable-gtk-update-checks" else "--disable-gtk")
  ];

  preBuild = ''
    cd build
  '';

  meta = {
    homepage = http://handbrake.fr/;
    description = "A tool for ripping DVDs into video files";
    longDescription = ''
      Handbrake is a versatile transcoding DVD ripper. This package
      provides the cli HandbrakeCLI and the GTK+ version ghb.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    # Not tested on anything else
    platforms = stdenv.lib.platforms.linux;
  };
}
