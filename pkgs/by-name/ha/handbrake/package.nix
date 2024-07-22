# Upstream distributes HandBrake with bundle of according versions of libraries
# and patches to them. This derivation patches HandBrake to use Nix closure
# dependencies.
#
# NOTE: 2019-07-19: This derivation does not currently support the native macOS
# GUI--it produces the "HandbrakeCLI" CLI version only. In the future it would
# be nice to add the native GUI (and/or the GTK GUI) as an option too, but that
# requires invoking the Xcode build system, which is non-trivial for now.

{ lib
, stdenv
, callPackage
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
, ffmpeg_7-full
, nv-codec-headers-9
, libogg
, x264
, x265
, libvpx
, libtheora
, dav1d
, zimg
, svt-av1
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
, darwin
  # GTK
  # NOTE: 2019-07-19: The gtk3 package has a transitive dependency on dbus,
  # which in turn depends on systemd. systemd is not supported on Darwin, so
  # for now we disable GTK GUI support on Darwin. (It may be possible to remove
  # this restriction later.)
, useGtk ? !stdenv.isDarwin
, appstream
, desktop-file-utils
, meson
, ninja
, wrapGAppsHook4
, intltool
, glib
, gtk4
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
  sources = callPackage ./sources.nix { };

  version = sources.handbrake.version;

  src = sources.handbrake.src;

  ffmpeg-hb = sources.ffmpeg-hb;

  x265-hb = sources.x265-hb;

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

  inherit (lib) optional optionals optionalString versions;

in
let
  self = stdenv.mkDerivation {
    pname = "handbrake";
    inherit version src;

    postPatch = ''
      install -Dm444 ${versionFile} ${versionFile.name}

      patchShebangs scripts
      patchShebangs gtk/data/

      substituteInPlace libhb/hb.c \
        --replace-fail 'return hb_version;' 'return "${self.version}";'

      # Force using nixpkgs dependencies
      sed -i '/MODULES += contrib/d' make/include/main.defs
      sed -e 's/^[[:space:]]*\(meson\|ninja\|nasm\)[[:space:]]*= ToolProbe.*$//g' \
          -e '/    ## Additional library and tool checks/,/    ## MinGW specific library and tool checks/d' \
          -i make/configure.py
    '' + optionalString stdenv.isDarwin ''
      # Prevent the configure script from failing if xcodebuild isn't available,
      # which it isn't in the Nix context. (The actual build goes fine without
      # xcodebuild.)
      sed -e '/xcodebuild = ToolProbe/s/abort=.\+)/abort=False)/' -i make/configure.py
    '' + optionalString useGtk ''
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
    ++ optionals useGtk [ appstream desktop-file-utils intltool meson ninja wrapGAppsHook4 ];

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
    ++ optionals stdenv.isDarwin
      ([ darwin.libobjc ]
       ++ (with darwin.apple_sdk.frameworks; [
         AudioToolbox Foundation VideoToolbox
       ]))
    # NOTE: 2018-12-27: Handbrake supports nv-codec-headers for Linux only,
    # look at ./make/configure.py search "enable_nvenc"
    ++ optionals stdenv.isLinux [ nv-codec-headers-9 ];

    configureFlags = [
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

      tests = {
        version = testers.testVersion {
          package = self;
          command = "HandBrakeCLI --version";
        };

        basic-conversion = callPackage ./tests/001-basic-conversion.nix {
          handbrake = self;
        };
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
      maintainers = with maintainers; [ Anton-Latukha wmertens ];
      platforms = with platforms; unix;
      broken = stdenv.isDarwin;  # https://github.com/NixOS/nixpkgs/pull/297984#issuecomment-2016503434
    };
  };
in
self
