# Upstream distributes HandBrake with bundle of according versions of libraries
# and patches to them. This derivation patches HandBrake to use Nix closure
# dependencies.
#
# NOTE: 2019-07-19: This derivation does not currently support the native macOS
# GUI--it produces the "HandbrakeCLI" CLI version only. In the future it would
# be nice to add the native GUI (and/or the GTK GUI) as an option too, but that
# requires invoking the Xcode build system, which is non-trivial for now.

{ stdenv
, lib
, fetchFromGitHub
  # For tests
, testers
, runCommand
, fetchurl
  # Main build tools
, pkg-config
, autoconf
, automake
, libtool
, m4
, xz
, python3
, numactl
, writeText
  # Processing, video codecs, containers
, ffmpeg-full
, nv-codec-headers
, libogg
, x264
, x265
, libvpx
, libtheora
, dav1d
, zimg
  # Codecs, audio
, libopus
, lame
, libvorbis
, a52dec
, speex
, libsamplerate
  # Text processing
, libiconv
, fribidi
, fontconfig
, freetype
, libass
, jansson
, libxml2
, harfbuzz
, libjpeg_turbo
  # Optical media
, libdvdread
, libdvdnav
, libdvdcss
, libbluray
  # Darwin-specific
, AudioToolbox
, Foundation
, libobjc
, VideoToolbox
  # GTK
  # NOTE: 2019-07-19: The gtk3 package has a transitive dependency on dbus,
  # which in turn depends on systemd. systemd is not supported on Darwin, so
  # for now we disable GTK GUI support on Darwin. (It may be possible to remove
  # this restriction later.)
, useGtk ? !stdenv.isDarwin
, wrapGAppsHook
, intltool
, glib
, gtk3
, libappindicator-gtk3
, libnotify
, gst_all_1
, dbus-glib
, udev
, libgudev
, hicolor-icon-theme
  # FDK
, useFdk ? false
, fdk_aac
}:

let
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "HandBrake";
    repo = "HandBrake";
    rev = version;
    sha256 = "1kk11zl1mk37d4cvbc75gfndmma7vy3vkp4gmkyl92kiz6zadhyy";
  };

  # Handbrake maintains a set of ffmpeg patches. In particular, these
  # patches are required for subtitle timing to work correctly. See:
  # https://github.com/HandBrake/HandBrake/issues/4029
  ffmpeg-version = "4.4.1";
  ffmpeg-hb = (ffmpeg-full.override { withSdl2 = false; }).overrideAttrs (old: {
    version = ffmpeg-version;
    src = fetchurl {
      url = "https://www.ffmpeg.org/releases/ffmpeg-${ffmpeg-version}.tar.bz2";
      hash = "sha256-j8nyCsXtlRFanihWR63Q7t1cwamKA5raFMEyRS+YrEI=";
    };
    patches = old.patches or [] ++ [
      "${src}/contrib/ffmpeg/A01-qsv-scale-fix-green-stripes.patch"
      "${src}/contrib/ffmpeg/A02-qsv-interpolation.patch"
      "${src}/contrib/ffmpeg/A03-qsv-dx11-ffmpeg44.patch"
      "${src}/contrib/ffmpeg/A04-configure-ensure-the-right-libmfx-version-is-used-wh.patch"
      "${src}/contrib/ffmpeg/A05-qsv-add-includedir-mfx-to-the-search-path-for-old-ve.patch"
      "${src}/contrib/ffmpeg/A06-qsv-load-user-plugin-for-MFX_VERSION-2.0.patch"
      "${src}/contrib/ffmpeg/A07-qsv-build-audio-related-code-when-MFX_VERSION-2.0.patch"
      "${src}/contrib/ffmpeg/A08-qsvenc-don-t-support-multi-frame-encode-when-MFX_VER.patch"
      "${src}/contrib/ffmpeg/A09-qsvenc-don-t-support-MFX_RATECONTROL_LA_EXT-when-MFX.patch"
      "${src}/contrib/ffmpeg/A10-qsv-don-t-support-OPAQUE-memory-when-MFX_VERSION-2.0.patch"
      "${src}/contrib/ffmpeg/A11-qsv-opaque-deinterlace.patch"
      "${src}/contrib/ffmpeg/A12-qsv-opaque-vpp.patch"
      "${src}/contrib/ffmpeg/A13-qsv-opaque-hwcontext_qsv.patch"
      "${src}/contrib/ffmpeg/A14-configure-check-mfxdefs.h-instead-of-mfxvp9.h-for-MF.patch"
      "${src}/contrib/ffmpeg/A15-configure-allow-user-to-build-FFmpeg-against-oneVPL.patch"
      "${src}/contrib/ffmpeg/A16-qsv-add-macro-QSV_ONEVPL-for-the-oneVPL-SDK.patch"
      "${src}/contrib/ffmpeg/A17-qsv-use-a-new-method-to-create-mfx-session-when-usin.patch"
      "${src}/contrib/ffmpeg/A18-qsv-new-method-hwcontext_qsv.patch"
      "${src}/contrib/ffmpeg/A19-qsv-fix-session-for-d3d11-device.patch"
      "${src}/contrib/ffmpeg/A20-mov-read-name-track-tag-written-by-movenc.patch"
      "${src}/contrib/ffmpeg/A21-movenc-write-3gpp-track-titl-tag.patch"
      "${src}/contrib/ffmpeg/A22-mov-read-3gpp-udta-tags.patch"
      "${src}/contrib/ffmpeg/A23-movenc-write-3gpp-track-names-tags-for-all-available.patch"
      "${src}/contrib/ffmpeg/A24-FFmpeg-devel-amfenc-Add-support-for-pict_type-field.patch"
      "${src}/contrib/ffmpeg/A25-dvdsubdec-fix-processing-of-partial-packets.patch"
      "${src}/contrib/ffmpeg/A26-ccaption_dec-return-number-of-bytes-used.patch"
      "${src}/contrib/ffmpeg/A27-dvdsubdec-return-number-of-bytes-used.patch"
      "${src}/contrib/ffmpeg/A28-dvdsubdec-use-pts-of-initial-packet.patch"
      "${src}/contrib/ffmpeg/A29-matroskaenc-aac-extradata-updated.patch"
      "${src}/contrib/ffmpeg/A30-ccaption_dec-fix-pts-in-real_time-mode.patch"
      "${src}/contrib/ffmpeg/A32-qsv-fix-decode-10bit-hdr.patch"
    ];
  });

  versionFile = writeText "version.txt" ''
    BRANCH=${versions.majorMinor version}.x
    DATE=1970-01-01 00:00:01 +0000
    HASH=${src.rev}
    REV=${src.rev}
    SHORTHASH=${src.rev}
    TAG=${version}
    URL=${src.meta.homepage}
  '';

  inherit (lib) optional optionals optionalString versions;

in
let self = stdenv.mkDerivation rec {
  pname = "handbrake";
  inherit version src;

  postPatch = ''
    install -Dm444 ${versionFile} ${versionFile.name}

    patchShebangs scripts

    substituteInPlace libhb/hb.c \
      --replace 'return hb_version;' 'return "${version}";'

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -e 's/^[[:space:]]*\(meson\|ninja\|nasm\)[[:space:]]*= ToolProbe.*$//g' \
        -e '/    ## Additional library and tool checks/,/    ## MinGW specific library and tool checks/d' \
        -i make/configure.py
  '' + optionalString stdenv.isDarwin ''
    # Use the Nix-provided libxml2 instead of the patched version available on
    # the Handbrake website.
    substituteInPlace libhb/module.defs \
      --replace '$(CONTRIB.build/)include/libxml2' ${libxml2.dev}/include/libxml2

    # Prevent the configure script from failing if xcodebuild isn't available,
    # which it isn't in the Nix context. (The actual build goes fine without
    # xcodebuild.)
    sed -e '/xcodebuild = ToolProbe/s/abort=.\+)/abort=False)/' -i make/configure.py
  '' + optionalString stdenv.isLinux ''
    # Use the Nix-provided libxml2 instead of the system-provided one.
    substituteInPlace libhb/module.defs \
      --replace /usr/include/libxml2 ${libxml2.dev}/include/libxml2
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    m4
    pkg-config
    python3
  ]
  ++ optionals useGtk [ intltool wrapGAppsHook ];

  buildInputs = [
    a52dec
    dav1d
    ffmpeg-hb
    fontconfig
    freetype
    fribidi
    harfbuzz
    jansson
    lame
    libass
    libbluray
    libdvdcss
    libdvdnav
    libdvdread
    libiconv
    libjpeg_turbo
    libogg
    libopus
    libsamplerate
    libtheora
    libvorbis
    libvpx
    libxml2
    speex
    x264
    x265
    xz
    zimg
  ]
  ++ optional (!stdenv.isDarwin) numactl
  ++ optionals useGtk [
    dbus-glib
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    hicolor-icon-theme
    libappindicator-gtk3
    libgudev
    libnotify
    udev
  ]
  ++ optional useFdk fdk_aac
  ++ optionals stdenv.isDarwin [ AudioToolbox Foundation libobjc VideoToolbox ]
  # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
  # look at ./make/configure.py search "enable_nvenc"
  ++ optional stdenv.isLinux nv-codec-headers;

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
    "--disable-gtk-update-checks"
  ]
  ++ optional (!useGtk) "--disable-gtk"
  ++ optional useFdk "--enable-fdk-aac"
  ++ optional stdenv.isDarwin "--disable-xcode"
  ++ optional stdenv.hostPlatform.isx86 "--harden";

  # NOTE: 2018-12-27: Check NixOS HandBrake test if changing
  NIX_LDFLAGS = [ "-lx265" ];

  makeFlags = [ "--directory=build" ];

  passthru.tests = {
    basic-conversion =
      let
        # Big Buck Bunny example, licensed under CC Attribution 3.0.
        testMkv = fetchurl {
          url = "https://github.com/Matroska-Org/matroska-test-files/blob/cf0792be144ac470c4b8052cfe19bb691993e3a2/test_files/test1.mkv?raw=true";
          sha256 = "1hfxbbgxwfkzv85pvpvx55a72qsd0hxjbm9hkl5r3590zw4s75h9";
        };
      in
      runCommand "${pname}-${version}-basic-conversion" { nativeBuildInputs = [ self ]; } ''
        mkdir -p $out
        cd $out
        HandBrakeCLI -i ${testMkv} -o test.mp4 -e x264 -q 20 -B 160
        test -e test.mp4
        HandBrakeCLI -i ${testMkv} -o test.mkv -e x264 -q 20 -B 160
        test -e test.mkv
      '';
    version = testers.testVersion { package = self; command = "HandBrakeCLI --version"; };
  };

  meta = with lib; {
    homepage = "https://handbrake.fr/";
    description = "A tool for converting video files and ripping DVDs";
    longDescription = ''
      Tool for converting and remuxing video files
      into selection of modern and widely supported codecs
      and containers. Very versatile and customizable.
      Package provides:
      CLI - `HandbrakeCLI`
      GTK GUI - `ghb`
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ Anton-Latukha wmertens ];
    platforms = with platforms; unix;
    broken = stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13";
  };
};
in self
