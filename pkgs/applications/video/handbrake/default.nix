# Upstream distributes HandBrake with bundle of according versions of libraries and patches to them.
#
# Derivation patches HandBrake to use Nix closure dependencies.
#
# NOTE: 2019-07-19: This derivation does not currently support the native macOS
# GUI--it produces the "HandbrakeCLI" CLI version only. In the future it would
# be nice to add the native GUI (and/or the GTK GUI) as an option too, but that
# requires invoking the Xcode build system, which is non-trivial for now.

{ stdenv, lib, fetchurl, fetchpatch,
  # Main build tools
  python2, pkgconfig, autoconf, automake, cmake, nasm, libtool, m4, lzma,
  # Processing, video codecs, containers
  ffmpeg-full, nv-codec-headers, libogg, x264, x265, libvpx, libtheora,
  # Codecs, audio
  libopus, lame, libvorbis, a52dec, speex, libsamplerate,
  # Text processing
  libiconv, fribidi, fontconfig, freetype, libass, jansson, libxml2, harfbuzz,
  # Optical media
  libdvdread, libdvdnav, libdvdcss, libbluray,
  # Darwin-specific
  AudioToolbox ? null,
  Foundation ? null,
  libobjc ? null,
  VideoToolbox ? null,
  # GTK
  # NOTE: 2019-07-19: The gtk3 package has a transitive dependency on dbus,
  # which in turn depends on systemd. systemd is not supported on Darwin, so
  # for now we disable GTK GUI support on Darwin. (It may be possible to remove
  # this restriction later.)
  useGtk ? !stdenv.isDarwin, wrapGAppsHook ? null,
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
  # FDK
  useFdk ? false, fdk_aac ? null
}:

assert stdenv.isDarwin -> AudioToolbox != null && Foundation != null
  && libobjc != null && VideoToolbox != null;

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
    libiconv fribidi fontconfig freetype libass jansson libxml2 harfbuzz
    libdvdread libdvdnav libdvdcss libbluray lzma
  ] ++ lib.optionals useGtk [
    glib gtk3 libappindicator-gtk3 libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus-glib udev
    libgudev hicolor-icon-theme
  ] ++ lib.optional useFdk fdk_aac
    ++ lib.optionals stdenv.isDarwin [ AudioToolbox Foundation libobjc VideoToolbox ]
  # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
  # look at ./make/configure.py search "enable_nvenc"
    ++ lib.optional stdenv.isLinux nv-codec-headers;

  # NOTE: 2018-12-25: v1.2.0 now requires cmake dep
  # (default distribution bundles&builds 3rd party libs),
  # don't trigger cmake build
  dontUseCmakeConfigure = true;
  # cp: cannot create regular file './internal_defaults.json': File exists
  enableParallelBuilding = false;

  # The samplerate patch should be removed when HandBrake 1.3.0 is released
  patches = [(fetchpatch {
    name = "set-ffmpeg-samplerate.patch";
    url = "https://patch-diff.githubusercontent.com/raw/HandBrake/HandBrake/pull/2126.patch";
    sha256 = "00lds9h27cvyr53qpvv8gbv01hfxdxd8gphxcwbwg8akqrvk9gbf";
  })];

  preConfigure = ''
    patchShebangs scripts

    substituteInPlace libhb/module.defs \
      --replace /usr/include/libxml2 ${libxml2.dev}/include/libxml2
    substituteInPlace libhb/module.defs \
      --replace '$(CONTRIB.build/)include/libxml2' ${libxml2.dev}/include/libxml2

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -i '/PKG_CONFIG_PATH=/d' gtk/module.rules
  '';

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
    (if useGtk          then "--disable-gtk-update-checks" else "--disable-gtk")
    (if useFdk          then "--enable-fdk-aac"            else "")
    (if stdenv.isDarwin then "--disable-xcode"             else "")
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
      GTK GUI - `ghb`
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ Anton-Latukha wmertens ];
    platforms = with platforms; unix;
  };
}
