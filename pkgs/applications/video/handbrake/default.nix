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

{ stdenv, lib, fetchFromGitHub,
  python2, pkgconfig, yasm, harfbuzz, zlib,
  autoconf, automake, cmake, libtool, m4, jansson,
  libass, libiconv, libsamplerate, fribidi, libxml2, bzip2,
  libogg, libopus, libtheora, libvorbis, libdvdcss, a52dec, fdk_aac,
  lame, ffmpeg, libdvdread, libdvdnav, libbluray,
  mp4v2, mpeg2dec, x264, x265, libmkv,
  fontconfig, freetype, hicolor-icon-theme,
  glib, gtk3, intltool, libnotify,
  gst_all_1, dbus-glib, udev, libgudev, libvpx,
  useGtk ? true, wrapGAppsHook ? null, libappindicator-gtk3 ? null
}:

stdenv.mkDerivation rec {
  version = "1.0.7";
  name = "handbrake-${version}";

  src = fetchFromGitHub {
    owner  = "HandBrake";
    repo   = "HandBrake";
    rev    = "${version}";
    sha256 = "1pdrvicq40s8n23n6k8k097kkjs3ah5wbz1mvxnfy3h2mh5rwk57";
  };

  nativeBuildInputs = [
    cmake python2 pkgconfig yasm autoconf automake libtool m4
  ] ++ (lib.optionals useGtk [
    intltool wrapGAppsHook
  ]);

  buildInputs = [
    fribidi fontconfig freetype jansson zlib
    libass libiconv libsamplerate libxml2 bzip2
    libogg libopus libtheora libvorbis libdvdcss a52dec libmkv fdk_aac
    lame ffmpeg libdvdread libdvdnav libbluray mp4v2 mpeg2dec x264 x265 libvpx
  ] ++ (lib.optionals useGtk [
    glib gtk3 libappindicator-gtk3 libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus-glib udev
    libgudev
  ]);

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs scripts

    echo 'TAG=${version}' > version.txt

    # `configure` errors out when trying to read the current year which is too low
    substituteInPlace make/configure.py \
      --replace developer release \
      --replace 'repo.date.strftime("%Y-%m-%d %H:%M:%S")' '""'

    substituteInPlace libhb/module.defs \
      --replace /usr/include/libxml2 ${libxml2.dev}/include/libxml2

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -i '/PKG_CONFIG_PATH=/d' gtk/module.rules
  '';

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
    "--enable-fdk-aac"
    (if useGtk then "--disable-gtk-update-checks" else "--disable-gtk")
  ];

  NIX_LDFLAGS = [
    "-lx265"
  ];

  preBuild = ''
    cd build
  '';

  # icon-theme.cache belongs in the icon theme, not in individual packages
  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = http://handbrake.fr/;
    description = "A tool for ripping DVDs into video files";
    longDescription = ''
      Handbrake is a versatile transcoding DVD ripper. This package
      provides the cli HandbrakeCLI and the GTK+ version ghb.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ wmertens ];
    # Not tested on anything else
    platforms = platforms.linux;
  };
}
