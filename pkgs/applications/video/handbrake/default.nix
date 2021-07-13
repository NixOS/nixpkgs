# Upstream distributes HandBrake with bundle of according versions of libraries
# and patches to them. This derivation patches HandBrake to use Nix closure
# dependencies.
#
# NOTE: 2019-07-19: This derivation does not currently support the native macOS
# GUI--it produces the "HandbrakeCLI" CLI version only. In the future it would
# be nice to add the native GUI (and/or the GTK GUI) as an option too, but that
# requires invoking the Xcode build system, which is non-trivial for now.

{ stdenv, lib, fetchFromGitHub, fetchpatch,
  # Main build tools
  pkg-config, autoconf, automake, libtool, m4, xz, python3,
  numactl,
  # Processing, video codecs, containers
  ffmpeg-full, nv-codec-headers, libogg, x264, x265, libvpx, libtheora, dav1d,
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

stdenv.mkDerivation rec {
  pname = "handbrake";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "HandBrake";
    repo = "HandBrake";
    rev = version;
    sha256 = "0bsmk37543zv3p32a7wxnh2w483am23ha2amj339q3nnb4142krn";
    extraPostFetch = ''
      echo "DATE=$(date +"%F %T %z" -r $out/NEWS.markdown)" > $out/version.txt
    '';
  };

  # Remove with a release after 1.3.3
  patches = [
    (fetchpatch {
      name = "audio-fix-ffmpeg-4_4";
      url = "https://github.com/HandBrake/HandBrake/commit/f28289fb06ab461ea082b4be56d6d1504c0c31c2.patch";
      sha256 = "sha256:1zcwa4h97d8wjspb8kbd8b1jg0a9vvmv9zaphzry4m9q0bj3h3kz";
    })
  ];

  # we put as little as possible in src.extraPostFetch as it's much easier to
  # add to it here without having to fiddle with src.sha256
  # only DATE and HASH are absolutely necessary
  postPatch = ''
    cat >> version.txt <<_EOF
HASH=${src.rev}
SHORTHASH=${src.rev}
TAG=${version}
URL=${src.meta.homepage}
_EOF

    patchShebangs scripts

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -e 's/^[[:space:]]*\(meson\|ninja\|nasm\)[[:space:]]*= ToolProbe.*$//g' \
        -e '/    ## Additional library and tool checks/,/    ## MinGW specific library and tool checks/d' \
        -i make/configure.py
  '' + (lib.optionalString stdenv.isDarwin ''
    # Use the Nix-provided libxml2 instead of the patched version available on
    # the Handbrake website.
    substituteInPlace libhb/module.defs \
      --replace '$(CONTRIB.build/)include/libxml2' ${libxml2.dev}/include/libxml2

    # Prevent the configure script from failing if xcodebuild isn't available,
    # which it isn't in the Nix context. (The actual build goes fine without
    # xcodebuild.)
    sed -e '/xcodebuild = ToolProbe/s/abort=.\+)/abort=False)/' -i make/configure.py
  '') + (lib.optionalString stdenv.isLinux ''
    # Use the Nix-provided libxml2 instead of the system-provided one.
    substituteInPlace libhb/module.defs \
      --replace /usr/include/libxml2 ${libxml2.dev}/include/libxml2
  '');

  nativeBuildInputs = [
    pkg-config autoconf automake libtool m4 python3
  ] ++ lib.optionals useGtk [ intltool wrapGAppsHook ];

  buildInputs = [
    ffmpeg-full libogg libtheora x264 x265 libvpx dav1d
    libopus lame libvorbis a52dec speex libsamplerate
    libiconv fribidi fontconfig freetype libass jansson libxml2 harfbuzz
    libdvdread libdvdnav libdvdcss libbluray xz
  ] ++ lib.optional (!stdenv.isDarwin) numactl
  ++ lib.optionals useGtk [
    glib gtk3 libappindicator-gtk3 libnotify
    gst_all_1.gstreamer gst_all_1.gst-plugins-base dbus-glib udev
    libgudev hicolor-icon-theme
  ] ++ lib.optional useFdk fdk_aac
  ++ lib.optionals stdenv.isDarwin [ AudioToolbox Foundation libobjc VideoToolbox ]
  # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
  # look at ./make/configure.py search "enable_nvenc"
  ++ lib.optional stdenv.isLinux nv-codec-headers;

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
    (if useGtk          then "--disable-gtk-update-checks" else "--disable-gtk")
    (if useFdk          then "--enable-fdk-aac"            else "")
    (if stdenv.isDarwin then "--disable-xcode"             else "")
  ] ++ lib.optional (stdenv.isx86_32 || stdenv.isx86_64) "--harden";

  # NOTE: 2018-12-27: Check NixOS HandBrake test if changing
  NIX_LDFLAGS = [
    "-lx265"
  ];

  preBuild = ''
    cd build
  '';

  meta = with lib; {
    homepage = "http://handbrake.fr/";
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
