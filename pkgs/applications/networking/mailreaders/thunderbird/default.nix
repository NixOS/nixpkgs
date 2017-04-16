{ lib, stdenv, fetchurl, pkgconfig, gtk2, pango, perl, python, zip, libIDL
, libjpeg, zlib, dbus, dbus_glib, bzip2, xorg
, freetype, fontconfig, file, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip
, hunspell, libevent, libstartup_notification
, cairo, gstreamer, gst-plugins-base, icu, libpng, jemalloc
, autoconf213, which, m4
, writeScript, xidel, common-updater-scripts, coreutils, gnused, gnugrep, curl
, enableGTK3 ? false, gtk3, wrapGAppsHook
, enableCalendar ? true
, debugBuild ? false
, # If you want the resulting program to call itself "Thunderbird" instead
  # of "Earlybird" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

stdenv.mkDerivation rec {
  name = "thunderbird-${version}";
  version = "52.0.1";

  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "7b8324a230a10b738b9a28c31b195bfb149b1f47eec6662d93a7d0c424d56303dbc2bca6645b30323c6da86628d6e49de359e1067081a5d0bd66541174a8be48";
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
    ++ lib.optional enableGTK3 gtk3;

  # from firefox + m4
  nativeBuildInputs = [ m4 autoconf213 which gnused pkgconfig perl python ] ++ lib.optional enableGTK3 wrapGAppsHook;

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

  postInstall =
    ''
      # For grsecurity kernels
      paxmark m $out/lib/thunderbird-[0-9]*/thunderbird

      # Needed to find Mozilla runtime
      gappsWrapperArgs+=(--argv0 "$out/bin/.thunderbird-wrapped")
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
