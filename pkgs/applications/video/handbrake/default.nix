# Handbrake normally uses its own copies of the libraries it uses, for better
# control over library patches.
#
# This derivation patches HB so it doesn't do that. The relevant patches
# are added to the Nix packages and proposed upstream instead. In several cases
# upstream already incorporated these patches.
# This has the benefits of providing improvements to other packages,
# making licenses more clear and reducing compile time/install size.
#
# For compliance, the unfree codec faac is optionally spliced out.
#
# Only tested on Linux
#
# TODO: package and use libappindicator

{ stdenv, config, fetchurl,
  python, pkgconfig, yasm,
  autoconf, automake, libtool, m4,
  libass, libsamplerate, fribidi, libxml2, bzip2,
  libogg, libtheora, libvorbis, libdvdcss, a52dec, fdk_aac,
  lame, faac, ffmpeg, libdvdread, libdvdnav, libbluray,
  mp4v2, mpeg2dec, x264, libmkv,
  fontconfig, freetype,
  glib, gtk, webkitgtk, intltool, libnotify,
  gst_all_1, dbus_glib, udev,
  useGtk ? true,
  useWebKitGtk ? false # This prevents ghb from starting in my tests
}:

stdenv.mkDerivation rec {
  version = "0.9.9";
  name = "handbrake-${version}";

  # ToDo: doesn't work (yet)
  allowUnfree = false; # config.allowUnfree or false;

  buildInputsX = stdenv.lib.optionals useGtk [
    glib gtk intltool libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus_glib udev
  ] ++ stdenv.lib.optionals useWebKitGtk [ webkitgtk ];

  # Did not test compiling with it
  unfreeInputs = stdenv.lib.optional allowUnfree faac;

  nativeBuildInputs = [ python pkgconfig yasm autoconf automake libtool m4 ];
  buildInputs = [
    fribidi fontconfig freetype
    libass libsamplerate libxml2 bzip2
    libogg libtheora libvorbis libdvdcss a52dec libmkv fdk_aac
    lame ffmpeg libdvdread libdvdnav libbluray mp4v2 mpeg2dec x264
  ] ++ buildInputsX ++ unfreeInputs;


  src = fetchurl {
    name = "HandBrake-${version}.tar.bz2";
    url = "http://handbrake.fr/rotation.php?file=HandBrake-${version}.tar.bz2";
    sha256 = "1crmm1c32vx60jfl2bqzg59q4qqx6m83b08snp7h1njc21sdf7d7";
  };

  patches = stdenv.lib.optional (! allowUnfree) ./disable-unfree.patch;

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

    # disable faac if non-free
    if [ -z "$allowUnfree" ]; then
      rm libhb/encfaac.c
    fi
  '';

  configureFlags = "--enable-fdk-aac ${if useGtk then "--disable-gtk-update-checks" else "--disable-gtk"}";

  preBuild = ''
    cd build
  '';

  meta = {
    homepage = http://handbrake.fr/;
    description = "A tool for ripping DVDs into video files";
    longDescription = ''
      Handbrake is a versatile transcoding DVD ripper. This package
      provides the cli HandbrakeCLI and the GTK+ version ghb.
      The faac library is disabled if you're compiling free-only.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    # Not tested on anything else
    platforms = stdenv.lib.platforms.linux;
  };
}
