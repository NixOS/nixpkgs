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
  # GTK
  # NOTE: 2019-07-19: The gtk3 package has a transitive dependency on dbus,
  # which in turn depends on systemd. systemd is not supported on Darwin, so
  # for now we disable GTK GUI support on Darwin. (It may be possible to remove
  # this restriction later.)
  useGtk ? !stdenv.hostPlatform.isDarwin,
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
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "HandBrake";
    repo = "HandBrake";
    # uses version commit for logic in version.txt
    rev = "dddf75f756e56d2b8dbb0609175bc12047a4841d";
    hash = "sha256-CIMpJDJ0IIz95f3/zxeQqpCFpHWEmdgA+VaaUDY516A=";
  };

  # Handbrake maintains a set of ffmpeg patches. In particular, these
  # patches are required for subtitle timing to work correctly. See:
  # https://github.com/HandBrake/HandBrake/issues/4029
  # base ffmpeg version is specified in:
  # https://github.com/HandBrake/HandBrake/blob/master/contrib/ffmpeg/module.defs
  ffmpeg-version = "7.1.1";
  ffmpeg-hb =
    (ffmpeg_7-full.override {
      version = ffmpeg-version;
      hash = "sha256-GyS8imOqfOUPxXrzCiQtzCQIIH6bvWmQAB0fKUcRsW4=";
    }).overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          "${src}/contrib/ffmpeg/A01-mov-read-name-track-tag-written-by-movenc.patch"
          "${src}/contrib/ffmpeg/A02-movenc-write-3gpp-track-titl-tag.patch"
          "${src}/contrib/ffmpeg/A03-mov-read-3gpp-udta-tags.patch"
          "${src}/contrib/ffmpeg/A04-movenc-write-3gpp-track-names-tags-for-all-available.patch"
          "${src}/contrib/ffmpeg/A05-avformat-mov-add-support-audio-fallback-track-ref.patch"
          "${src}/contrib/ffmpeg/A06-dvdsubdec-fix-processing-of-partial-packets.patch"
          "${src}/contrib/ffmpeg/A07-dvdsubdec-return-number-of-bytes-used.patch"
          "${src}/contrib/ffmpeg/A08-dvdsubdec-use-pts-of-initial-packet.patch"
          "${src}/contrib/ffmpeg/A09-dvdsubdec-add-an-option-to-output-subtitles-with-emp.patch"
          "${src}/contrib/ffmpeg/A10-ccaption_dec-fix-pts-in-real_time-mode.patch"
          "${src}/contrib/ffmpeg/A11-avformat-matroskaenc-return-error-if-aac-extradata-c.patch"
          "${src}/contrib/ffmpeg/A12-videotoolbox-disable-H.264-10-bit-on-Intel-macOS-it-.patch"

          # patch to fix <https://github.com/HandBrake/HandBrake/issues/5011>
          # commented out because it causes ffmpeg's filter-pixdesc-p010le test to fail.
          # "${src}/contrib/ffmpeg/A13-libswscale-fix-yuv420p-to-p01xle-color-conversion-bu.patch"

          "${src}/contrib/ffmpeg/A14-hevc_mp4toannexb.c-fix-qsv-decode-of-10bit-hdr.patch"
          "${src}/contrib/ffmpeg/A15-Expose-the-unmodified-Dolby-Vision-RPU-T35-buffers.patch"
          "${src}/contrib/ffmpeg/A16-avcodec-amfenc-Add-support-for-on-demand-key-frames.patch"
          "${src}/contrib/ffmpeg/A17-avcodec-amfenc-properly-set-primaries-transfer-and-m.patch"
          "${src}/contrib/ffmpeg/A18-libavcodec-qsvenc-update-has_b_frames-value.patch"
          "${src}/contrib/ffmpeg/A19-libavcodec-qsv-enable-av1-scc.patch"
          "${src}/contrib/ffmpeg/A20-Revert-avcodec-amfenc-GPU-driver-version-check.patch"
          "${src}/contrib/ffmpeg/A21-lavc-pgssubdec-Add-graphic-plane-and-cropping.patch"
          "${src}/contrib/ffmpeg/A22-avformat-mov-read-and-write-additional-iTunes-style-.patch"
          "${src}/contrib/ffmpeg/A23-avformat-movenc-write-iTunEXTC-and-iTunMOVI-metadata.patch"
          "${src}/contrib/ffmpeg/A24-AV1-videotoolbox.patch"
          "${src}/contrib/ffmpeg/A25-videotoolbox-speedup-decoding.patch"
          "${src}/contrib/ffmpeg/A28-enable-av1_mf-encoder.patch"
          "${src}/contrib/ffmpeg/A30-qsv-fixed-BT2020-BT709-conversion.patch"
          "${src}/contrib/ffmpeg/A31-Parse-EAC3-Atmos-ComplexityIndex-for-MP4-remuxing.patch"
        ];
      });

  x265-hb = x265.overrideAttrs (old: {
    version = "4.1";
    sourceRoot = "x265_4.1/source";
    src = fetchurl {
      url = "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.1.tar.gz";
      hash = "sha256-oxaZxqiYBrdLAVHl5qffZd5LSQUEgv5ev4pDedevjyk=";
    };
    # nixpkgs' x265 sourceRoot is x265-.../source whereas handbrake's x265 patches
    # are written with respect to the parent directory instead of that source directory.
    # patches which don't cleanly apply are commented out.
    postPatch = (old.postPatch or "") + ''
      pushd ..
      patch -p1 < ${src}/contrib/x265/A01-Do-not-set-thread-priority-on-Windows.patch
      patch -p1 < ${src}/contrib/x265/A02-Apple-Silicon-tuning.patch
      patch -p1 < ${src}/contrib/x265/A03-Implement-ambient-viewing-environment-sei.patch
      patch -p1 < ${src}/contrib/x265/A04-add-new-matrix-coefficients-from-H.273-v3.patch
      patch -p1 < ${src}/contrib/x265/A05-Fix-Dolby-Vision-RPU-memory-management.patch
      # patch -p1 < ${src}/contrib/x265/A06-Update-version-strings.patch
      patch -p1 < ${src}/contrib/x265/A07-Fix-macOS-cross-compilation.patch
      # patch -p1 < ${src}/contrib/x265/A08-Fix-inconsistent-bitrate-in-second-pass.patch
      patch -p1 < ${src}/contrib/x265/A09-Ensuring-the-mvdLX-is-compliant.patch
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
    ;

  self = stdenv.mkDerivation rec {
    pname = "handbrake";
    inherit version src;

    postPatch = ''
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
    + optionalString stdenv.hostPlatform.isDarwin ''
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

    nativeBuildInputs = [
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
      svt-av1
      x264
      x265-hb
      xz
      zimg
    ]
    ++ optional (!stdenv.hostPlatform.isDarwin) numactl
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
    # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
    # look at ./make/configure.py search "enable_nvenc"
    ++ optional stdenv.hostPlatform.isLinux nv-codec-headers;

    configureFlags = [
      "--disable-df-fetch"
      "--disable-df-verify"
    ]
    ++ optional (!useGtk) "--disable-gtk"
    ++ optional useFdk "--enable-fdk-aac"
    ++ optional stdenv.hostPlatform.isDarwin "--disable-xcode"
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

    meta = {
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
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [
        Anton-Latukha
        wmertens
      ];
      mainProgram = "HandBrakeCLI";
      platforms = with lib.platforms; unix;
      broken = stdenv.hostPlatform.isDarwin; # https://github.com/NixOS/nixpkgs/pull/297984#issuecomment-2016503434
    };
  };
in
self
