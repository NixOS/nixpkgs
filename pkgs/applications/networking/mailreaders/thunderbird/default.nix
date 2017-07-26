{ lib, stdenv, fetchurl, pkgconfig, gtk2, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip
, hunspell, libevent, libstartup_notification
, cairo, gstreamer, gst-plugins-base, icu, libpng, jemalloc
, autoconf213, which, m4
, writeScript, xidel, common-updater-scripts, coreutils, gnused, gnugrep, curl
, enableGTK3 ? false, gtk3, gnome3, wrapGAppsHook, makeWrapper
, enableCalendar ? true
, debugBuild ? false
, # If you want the resulting program to call itself "Thunderbird" instead
  # of "Earlybird" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
, makeDesktopItem
}:

let
  wrapperTool = if enableGTK3 then wrapGAppsHook else makeWrapper;
in stdenv.mkDerivation rec {
  name = "thunderbird-${version}";
  version = "52.2.1";

  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "f30ba358b1bfc57265b26da3d2205a8a77c6cd1987278de40cde6c1c1241db3c2fedc60aebb6ff56ffb340492c5580294420158f4b7c4787f558e79f72e3d7fb";
  };

  # New sed no longer tolerates this mistake.
  postPatch = ''
    for f in mozilla/{js/src,}/configure; do
      substituteInPlace "$f" --replace '[:space:]*' '[[:space:]]*'
    done
  '';

  # from firefox, but without sound libraries
  buildInputs =
    [ gtk2 zip libIDL libjpeg zlib bzip2
      dbus dbus_glib pango freetype fontconfig xorg.libXi
      xorg.libX11 xorg.libXrender xorg.libXft xorg.libXt file
      nspr nss libnotify xorg.pixman yasm mesa
      xorg.libXScrnSaver xorg.scrnsaverproto
      xorg.libXext xorg.xextproto sqlite unzip
      hunspell libevent libstartup_notification /* cairo */
      icu libpng jemalloc
    ]
    ++ lib.optionals enableGTK3 [ gtk3 gnome3.defaultIconTheme ];

  # from firefox + m4 + wrapperTool
  nativeBuildInputs = [ m4 autoconf213 which gnused pkgconfig perl python wrapperTool ];

  configureFlags =
    [ # from firefox, but without sound libraries (alsa, libvpx, pulseaudio)
      "--enable-application=mail"
      "--disable-alsa"
      "--disable-pulseaudio"

      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-libevent"
      "--with-system-png" # needs APNG support
      "--with-system-icu"
      "--enable-system-ffi"
      "--enable-system-hunspell"
      "--enable-system-pixman"
      "--enable-system-sqlite"
      #"--enable-system-cairo"
      "--enable-startup-notification"
      "--enable-content-sandbox"            # available since 26.0, but not much info available
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-updater"
      "--enable-jemalloc"
      "--disable-gconf"
      "--enable-default-toolkit=cairo-gtk${if enableGTK3 then "3" else "2"}"
    ]
      ++ lib.optional enableCalendar "--enable-calendar"
      ++ (if debugBuild then [ "--enable-debug" "--enable-profiling"]
                        else [ "--disable-debug" "--enable-release"
                               "--disable-debug-symbols"
                               "--enable-optimize" "--enable-strip" ])
      ++ lib.optional enableOfficialBranding "--enable-official-branding";

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureScript="$(realpath ./configure)"
      mkdir ../objdir
      cd ../objdir
    '';

  preInstall =
    ''
      # The following is needed for startup cache creation on grsecurity kernels.
      paxmark m ../objdir/dist/bin/xpcshell
    '';

  dontWrapGApps = true; # we do it ourselves
  postInstall =
    ''
      # For grsecurity kernels
      paxmark m $out/lib/thunderbird-[0-9]*/thunderbird

      # TODO: Move to a dev output?
      rm -rf $out/include $out/lib/thunderbird-devel-* $out/share/idl

      # $binary is a symlink to $target.
      # We wrap $target by replacing the $binary symlink.
      local target="$out/lib/thunderbird-${version}/thunderbird"
      local binary="$out/bin/thunderbird"

      # Wrap correctly, this is needed to
      # 1) find Mozilla runtime, because argv0 must be the real thing,
      #    or a symlink thereto. It cannot be the wrapper itself
      # 2) detect itself as the default mailreader across builds
      gappsWrapperArgs+=(
        --argv0 "$target"
        --set MOZ_APP_LAUNCHER thunderbird
      )
      ${
        # We wrap manually because wrapGAppsHook does not detect the symlink
        # To mimic wrapGAppsHook, we run it with dontWrapGApps, so
        # gappsWrapperArgs gets defined correctly
        lib.optionalString enableGTK3 "wrapGAppsHook"
      }

      # "$binary" is a symlink, replace it by the wrapper
      rm "$binary"
      makeWrapper "$target" "$binary" "''${gappsWrapperArgs[@]}"

      ${ let desktopItem = makeDesktopItem {
          name = "thunderbird";
          exec = "thunderbird %U";
          desktopName = "Thunderbird";
          icon = "$out/lib/thunderbird-${version}/chrome/icons/default/default256.png";
          genericName = "Main Reader";
          categories = "Application;Network";
          mimeType = stdenv.lib.concatStringsSep ";" [
            # Email
            "x-scheme-handler/mailto"
            "message/rfc822"
            # Newsgroup
            "x-scheme-handler/news"
            "x-scheme-handler/snews"
            "x-scheme-handler/nntp"
            # Feed
            "x-scheme-handler/feed"
            "application/rss+xml"
            "application/x-extension-rss"
          ];
        }; in desktopItem.buildCommand
      }
    '';

  postFixup =
    # Fix notifications. LibXUL uses dlopen for this, unfortunately; see #18712.
    ''
      patchelf --set-rpath "${lib.getLib libnotify
        }/lib:$(patchelf --print-rpath "$out"/lib/thunderbird-*/libxul.so)" \
          "$out"/lib/thunderbird-*/libxul.so
    '';

  doInstallCheck = true;
  installCheckPhase =
    ''
      # Some basic testing
      "$out/bin/thunderbird" --version
    '';

  meta = with stdenv.lib; {
    description = "A full-featured e-mail client";
    homepage = http://www.mozilla.org/thunderbird/;
    license =
      # Official branding implies thunderbird name and logo cannot be reuse,
      # see http://www.mozilla.org/foundation/licensing.html
      if enableOfficialBranding then licenses.proprietary else licenses.mpl11;
    maintainers = [ maintainers.pierron maintainers.eelco ];
    platforms = platforms.linux;
  };

  passthru.updateScript = import ./../../browsers/firefox/update.nix {
    attrPath = "thunderbird";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
    inherit writeScript lib common-updater-scripts xidel coreutils gnused gnugrep curl;
  };
}
