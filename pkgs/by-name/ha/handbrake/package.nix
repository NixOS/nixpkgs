# Upstream distributes HandBrake with bundle of according versions of libraries
# and patches to them. This derivation patches HandBrake to use Nix closure
# dependencies.
#
# NOTE: 2019-07-19: This derivation does not currently support the native macOS
# GUI--it produces the "HandbrakeCLI" CLI version only. In the future it would
# be nice to add the native GUI (and/or the GTK GUI) as an option too, but that
# requires invoking the Xcode build system, which is non-trivial for now.

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  # For tests
  testers,
  runCommand,
  fetchurl,
  # Main build tools
  pkg-config,
  autoconf,
  automake,
  libtool,
  m4,
  xz,
  python3,
  numactl,
  writeText,
  # Processing, video codecs, containers
  ffmpeg_7-full,
  nv-codec-headers,
  libogg,
  x264,
  x265,
  libvpx,
  libtheora,
  dav1d,
  zimg,
  svt-av1,
  # Codecs, audio
  libopus,
  lame,
  libvorbis,
  a52dec,
  speex,
  libsamplerate,
  # Text processing
  libiconv,
  fribidi,
  fontconfig,
  freetype,
  libass,
  jansson,
  libxml2,
  harfbuzz,
  libjpeg_turbo,
  # Optical media
  libdvdread,
  libdvdnav,
  libdvdcss,
  libbluray,
  # Darwin-specific
  darwin,
  # GTK
  # NOTE: 2019-07-19: The gtk3 package has a transitive dependency on dbus,
  # which in turn depends on systemd. systemd is not supported on Darwin, so
  # for now we disable GTK GUI support on Darwin. (It may be possible to remove
  # this restriction later.)
  useGtk ? !stdenv.isDarwin,
  appstream,
  desktop-file-utils,
  meson,
  ninja,
  wrapGAppsHook4,
  intltool,
  glib,
  gtk4,
  libappindicator-gtk3,
  libnotify,
  gst_all_1,
  dbus-glib,
  udev,
  libgudev,
  hicolor-icon-theme,
  # FDK
  useFdk ? false,
  fdk_aac,
}:

let
  inherit (darwin.apple_sdk.frameworks)
    AudioToolbox
    Foundation
    VideoToolbox
    ;
  inherit (darwin) libobjc;
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "HandBrake";
    repo = "HandBrake";
    # uses version commit for logic in version.txt
    rev = "77f199ab02ff2e3bca4ca653e922e9fef67dec43";
    hash = "sha256-vxvmyo03NcO2Nbjg76JLZqmYw7RiK4FehiB+iE3CgOw=";
  };

  # Handbrake maintains a set of ffmpeg patches. In particular, these
  # patches are required for subtitle timing to work correctly. See:
  # https://github.com/HandBrake/HandBrake/issues/4029
  # base ffmpeg version is specified in:
  # https://github.com/HandBrake/HandBrake/blob/master/contrib/ffmpeg/module.defs
  ffmpeg-version = "7.0.2";
  ffmpeg-hb =
    (ffmpeg_7-full.override {
      version = ffmpeg-version;
      hash = "sha256-6bcTxMt0rH/Nso3X7zhrFNkkmWYtxsbUqVQKh25R1Fs=";
    }).overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          "${src}/contrib/ffmpeg/A01-mov-read-name-track-tag-written-by-movenc.patch"
          "${src}/contrib/ffmpeg/A02-movenc-write-3gpp-track-titl-tag.patch"
          "${src}/contrib/ffmpeg/A03-mov-read-3gpp-udta-tags.patch"
          "${src}/contrib/ffmpeg/A04-movenc-write-3gpp-track-names-tags-for-all-available.patch"
          "${src}/contrib/ffmpeg/A05-dvdsubdec-fix-processing-of-partial-packets.patch"
          "${src}/contrib/ffmpeg/A06-dvdsubdec-return-number-of-bytes-used.patch"
          "${src}/contrib/ffmpeg/A07-dvdsubdec-use-pts-of-initial-packet.patch"
          "${src}/contrib/ffmpeg/A08-dvdsubdec-do-not-discard-zero-sized-rects.patch"
          "${src}/contrib/ffmpeg/A09-ccaption_dec-fix-pts-in-real_time-mode.patch"
          "${src}/contrib/ffmpeg/A10-matroskaenc-aac-extradata-updated.patch"
          "${src}/contrib/ffmpeg/A11-videotoolbox-disable-H.264-10-bit-on-Intel-macOS.patch"

          # patch to fix <https://github.com/HandBrake/HandBrake/issues/5011>
          # commented out because it causes ffmpeg's filter-pixdesc-p010le test to fail.
          # "${src}/contrib/ffmpeg/A12-libswscale-fix-yuv420p-to-p01xle-color-conversion-bu.patch"

          "${src}/contrib/ffmpeg/A13-qsv-fix-decode-10bit-hdr.patch"
          "${src}/contrib/ffmpeg/A14-amfenc-Add-support-for-pict_type-field.patch"
          "${src}/contrib/ffmpeg/A15-amfenc-Fixes-the-color-information-in-the-ou.patch"
          "${src}/contrib/ffmpeg/A16-amfenc-HDR-metadata.patch"
          "${src}/contrib/ffmpeg/A17-av1dec-dovi-rpu.patch"
          "${src}/contrib/ffmpeg/A18-avformat-mov-add-support-audio-fallback-track-ref.patch"
        ];
      });

  x265-hb = x265.overrideAttrs (old: {
    # nixpkgs' x265 sourceRoot is x265-.../source whereas handbrake's x265 patches
    # are written with respect to the parent directory instead of that source directory.
    # patches which don't cleanly apply are commented out.
    postPatch =
      (old.postPatch or "")
      + ''
        pushd ..
        patch -p1 < ${src}/contrib/x265/A01-threads-priority.patch
        patch -p1 < ${src}/contrib/x265/A02-threads-pool-adjustments.patch
        patch -p1 < ${src}/contrib/x265/A03-sei-length-crash-fix.patch
        patch -p1 < ${src}/contrib/x265/A04-ambient-viewing-enviroment-sei.patch
        # patch -p1 < ${src}/contrib/x265/A05-memory-leaks.patch
        # patch -p1 < ${src}/contrib/x265/A06-crosscompile-fix.patch
        popd
      '';
  });

  versionFile = writeText "version.txt" ''
    URL=${src.meta.homepage}.git
    HASH=${src.rev}
    SHORTHASH=${lib.substring 0 9 src.rev}
    TAG=${version}
    TAG_HASH=${src.rev}
    REV=0
    BRANCH=
    REMOTE=${src.meta.homepage}.git
    DATE=1970-01-01 00:00:01 +0000
  '';

  inherit (lib)
    optional
    optionals
    optionalString
    versions
    ;

  self = stdenv.mkDerivation rec {
    pname = "handbrake";
    inherit version src;

    postPatch =
      ''
        install -Dm444 ${versionFile} ${versionFile.name}

        patchShebangs scripts
        patchShebangs gtk/data/

        substituteInPlace libhb/hb.c \
          --replace-fail 'return hb_version;' 'return "${version}";'

        # Force using nixpkgs dependencies
        sed -i '/MODULES += contrib/d' make/include/main.defs
        sed -e 's/^[[:space:]]*\(meson\|ninja\|nasm\)[[:space:]]*= ToolProbe.*$//g' \
            -e '/    ## Additional library and tool checks/,/    ## MinGW specific library and tool checks/d' \
            -i make/configure.py
      ''
      + optionalString stdenv.isDarwin ''
        # Prevent the configure script from failing if xcodebuild isn't available,
        # which it isn't in the Nix context. (The actual build goes fine without
        # xcodebuild.)
        sed -e '/xcodebuild = ToolProbe/s/abort=.\+)/abort=False)/' -i make/configure.py
      ''
      + optionalString useGtk ''
        substituteInPlace gtk/module.rules \
          --replace-fail '$(MESON.exe)' 'meson' \
          --replace-fail '$(NINJA.exe)' 'ninja' \
        # Force using nixpkgs dependencies
        substituteInPlace gtk/meson.build \
          --replace-fail \
            "hb_incdirs = include_directories(hb_dir / 'libhb', hb_dir / 'contrib/include')" \
            "hb_incdirs = include_directories(hb_dir / 'libhb')"
        substituteInPlace gtk/ghb.spec \
          --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
        substituteInPlace gtk/data/post_install.py \
          --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
      '';

    nativeBuildInputs =
      [
        autoconf
        automake
        libtool
        m4
        pkg-config
        python3
      ]
      ++ optionals useGtk [
        appstream
        desktop-file-utils
        intltool
        meson
        ninja
        wrapGAppsHook4
      ];

    buildInputs =
      [
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
        svt-av1
        x264
        x265-hb
        xz
        zimg
      ]
      ++ optional (!stdenv.isDarwin) numactl
      ++ optionals useGtk [
        dbus-glib
        glib
        gst_all_1.gst-libav
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gstreamer
        gtk4
        hicolor-icon-theme
        libappindicator-gtk3
        libgudev
        libnotify
        udev
      ]
      ++ optional useFdk fdk_aac
      ++ optionals stdenv.isDarwin [
        AudioToolbox
        Foundation
        libobjc
        VideoToolbox
      ]
      # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
      # look at ./make/configure.py search "enable_nvenc"
      ++ optional stdenv.isLinux nv-codec-headers;

    configureFlags =
      [
        "--disable-df-fetch"
        "--disable-df-verify"
      ]
      ++ optional (!useGtk) "--disable-gtk"
      ++ optional useFdk "--enable-fdk-aac"
      ++ optional stdenv.isDarwin "--disable-xcode"
      ++ optional stdenv.hostPlatform.isx86 "--harden";

    # NOTE: 2018-12-27: Check NixOS HandBrake test if changing
    NIX_LDFLAGS = [ "-lx265" ];

    # meson/ninja are used only for the subprojects, not the toplevel
    dontUseMesonConfigure = true;
    dontUseMesonInstall = true;
    dontUseNinjaBuild = true;
    dontUseNinjaInstall = true;

    makeFlags = [ "--directory=build" ];

    passthru = {
      # for convenience
      inherit ffmpeg-hb x265-hb;

      tests.basic-conversion =
        let
          # Big Buck Bunny example, licensed under CC Attribution 3.0.
          testMkv = fetchurl {
            url = "https://github.com/Matroska-Org/matroska-test-files/blob/cf0792be144ac470c4b8052cfe19bb691993e3a2/test_files/test1.mkv?raw=true";
            hash = "sha256-CZajCf8glZELnTDVJTsETWNxVCl9330L2n863t9a3cE=";
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

      tests.version = testers.testVersion {
        package = self;
        command = "HandBrakeCLI --version";
      };
    };

    meta = with lib; {
      homepage = "https://handbrake.fr/";
      description = "Tool for converting video files and ripping DVDs";
      longDescription = ''
        Tool for converting and remuxing video files
        into selection of modern and widely supported codecs
        and containers. Very versatile and customizable.
        Package provides:
        CLI - `HandbrakeCLI`
        GTK GUI - `ghb`
      '';
      license = licenses.gpl2Only;
      maintainers = with maintainers; [
        Anton-Latukha
        wmertens
      ];
      mainProgram = "HandBrakeCLI";
      platforms = with platforms; unix;
      broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/297984#issuecomment-2016503434
    };
  };
in
self
