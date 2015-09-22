{ stdenv, fetchurl, config, bash
, alsaLib
, atk
, cairo
, cups
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk3
, libX11
, libXScrnSaver
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXinerama
, libXrender
, libXt
, libcanberra
, libgnome
, libgnomeui
, mesa
, nspr
, nss
, pango
, libheimdal
, libpulseaudio
, systemd
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  version = "1.0.0";

  name = "firefox-bin-developer-edition-launcher-${version}";

  phases = "installPhase";

  arch = if stdenv.system == "i686-linux"
    then "linux-i686"
    else "linux-x86_64";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib
      atk
      cairo
      cups
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk3
      libX11
      libXScrnSaver
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXinerama
      libXrender
      libXt
      libcanberra
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
      libheimdal
      libpulseaudio
      systemd
    ] + ":" + stdenv.lib.makeSearchPath "lib64" [
      stdenv.cc.cc
    ];

  launcher =
    ''
      #!${bash}/bin/bash

      set -u -e -o pipefail

      # Usage: launch_firefox_developer_edition ARGS
      #
      # Downloads and launch Firefox Developer Edition.
      # ARGS are passed to the Firefox.
      #
      # Environment variables:
      #   AURORA_UPDATE: if not empty, downloads latest binary. Default: TRUE
      #   AURORA_HOME: directory path to install the binary. Default: ~/.firefox_aurora
      #

      if [[ ! -v AURORA_UPDATE ]]
      then
        AURORA_UPDATE=TRUE
      fi

      AURORA_HOME=''${AURORA_HOME:-$HOME/.firefox_aurora}

      if [[ ! -a "$AURORA_HOME/archives" ]]
      then
        echo "creating directory \"$AURORA_HOME/archives\""
        mkdir -p "$AURORA_HOME/archives"
      fi

      if [[ -n "$AURORA_UPDATE" || ! -a "$AURORA_HOME/firefox/firefox" ]]
      then
        BASE_URL=http://archive.mozilla.org/pub/firefox/nightly/latest-mozilla-aurora

        FILENAME=$(
          curl "$BASE_URL/" |
            grep 'firefox-[^\"]*\.en-US\.${arch}.tar.bz2' -o |
            head -n 1
        )

        ARCHIVE_FILE="$AURORA_HOME/archives/$FILENAME"
        HEADER_FILE="$AURORA_HOME/last_headers.txt"
        TMP_FILE="$AURORA_HOME/archives/download_tmp"

        echo "downloading \"$FILENAME\""

        if [[ -a "$HEADER_FILE" ]]
        then
          ETAG=$( sed -n -e '/^etag:/I s/.*\(".*"\)/\1/ p' "$HEADER_FILE" )
        else
          ETAG=
        fi

        curl "$BASE_URL/$FILENAME" \
          -o "$TMP_FILE" \
          -D "$HEADER_FILE" \
          ''${ETAG:+-H "If-None-Match: $ETAG"}

        if $( head "$HEADER_FILE" | grep -q 200 )
        then
          mv "$TMP_FILE" "$ARCHIVE_FILE"

          echo "unpacking"

          cd "$AURORA_HOME"

          tar xvf "$ARCHIVE_FILE"

          cd firefox

          for executable in \
            firefox firefox-bin plugin-container \
            updater crashreporter webapprt-stub
          do
            patchelf --interpreter \
              "${stdenv.glibc}/lib/${stdenv.cc.dynamicLinker}" \
              "$executable"
          done

          find . -executable -type f -exec \
            patchelf --set-rpath "${libPath}" "{}" \;
        else
          rm "$TMP_FILE"
        fi
      fi

      XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${gtk3}/share/gsettings-schemas/${gtk3.name} "$AURORA_HOME/firefox/firefox" "$@"
    '';

  installPhase =
    ''
      mkdir -p "$out/bin"

      echo "$launcher" > "$out/bin/launch_firefox_developer_edition"
      chmod +x "$out/bin/launch_firefox_developer_edition"
    '';

  meta = with stdenv.lib; {
    description = "Downloader and launcher for Mozilla Firefox Developer Edition";
    platforms = platforms.linux;
  };
}
