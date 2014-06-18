{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa, sqlite, unzip, makeWrapper, pysqlite
, hunspell, libevent, libstartup_notification, libvpx
, cairo, gstreamer, gst_plugins_base, icu
, debugBuild ? false
, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

assert stdenv.gcc ? libc && stdenv.gcc.libc != null;

rec {

  firefoxVersion = "30.0";

  xulVersion = "30.0"; # this attribute is used by other packages


  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.bz2";
    sha1 = "bll9hxf31gvg9db6gxgmq25qsjif3p11";
  };

  commonConfigureFlags =
    [ "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--with-system-nss"
      "--with-system-libevent"
      "--with-system-libvpx"
      "--with-system-png"
      # "--with-system-icu" # causes ‘ar: invalid option -- 'L'’ in Firefox 28.0
      "--enable-system-ffi"
      "--enable-system-hunspell"
      "--enable-system-pixman"
      "--enable-system-sqlite"
      "--enable-system-cairo"
      "--enable-gstreamer"
      "--enable-startup-notification"
      # "--enable-content-sandbox"            # available since 26.0, but not much info available
      # "--enable-content-sandbox-reporter"   # keeping disabled for now
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-installer"
      "--disable-updater"
      "--disable-pulseaudio"
    ] ++ (if debugBuild then [ "--enable-debug" "--enable-profiling"]
                        else [ "--disable-debug" "--enable-release"
                               "--enable-optimize" "--enable-strip" ]);


  xulrunner = stdenv.mkDerivation rec {
    name = "xulrunner-${xulVersion}";

    inherit src;

    buildInputs =
      [ pkgconfig libpng gtk perl zip libIDL libjpeg zlib bzip2
        python dbus dbus_glib pango freetype fontconfig xlibs.libXi
        xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
        alsaLib nspr nss libnotify xlibs.pixman yasm mesa
        xlibs.libXScrnSaver xlibs.scrnsaverproto pysqlite
        xlibs.libXext xlibs.xextproto sqlite unzip makeWrapper
        hunspell libevent libstartup_notification libvpx cairo
        gstreamer gst_plugins_base icu
      ];

    configureFlags =
      [ "--enable-application=xulrunner"
        "--disable-javaxpcom"
      ] ++ commonConfigureFlags;

    #enableParallelBuilding = true; # cf. https://github.com/NixOS/nixpkgs/pull/1699#issuecomment-35196282

    preConfigure =
      ''
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib/xulrunner-${xulVersion}"

        mkdir ../objdir
        cd ../objdir
        configureScript=../mozilla-release/configure
      ''; # */

    #installFlags = "SKIP_GRE_REGISTRATION=1";

    preInstall = ''
      # The following is needed for startup cache creation on grsecurity kernels
      paxmark m ../objdir/dist/bin/xpcshell
    '';

    postInstall = ''
      # Fix run-mozilla.sh search
      libDir=$(cd $out/lib && ls -d xulrunner-[0-9]*)
      echo libDir: $libDir
      test -n "$libDir"
      cd $out/bin
      rm xulrunner

      for i in $out/lib/$libDir/*; do
          file $i;
          if file $i | grep executable &>/dev/null; then
              echo -e '#! /bin/sh\nexec "'"$i"'" "$@"' > "$out/bin/$(basename "$i")";
              chmod a+x "$out/bin/$(basename "$i")";
          fi;
      done
      for i in $out/lib/$libDir/*.so; do
          patchelf --set-rpath "$(patchelf --print-rpath "$i"):$out/lib/$libDir" $i || true
      done

      # For grsecurity kernels
      paxmark m $out/lib/$libDir/{plugin-container,xulrunner}

      for i in $out/lib/$libDir/{plugin-container,xulrunner,xulrunner-stub}; do
          wrapProgram $i --prefix LD_LIBRARY_PATH ':' "$out/lib/$libDir"
      done

      rm -f $out/bin/run-mozilla.sh
    ''; # */

    meta = {
      description = "Mozilla Firefox XUL runner";
      homepage = http://www.mozilla.com/en-US/firefox/;
    };

    passthru = { inherit gtk; version = xulVersion; };
  };


  firefox = stdenv.mkDerivation rec {
    name = "firefox-${firefoxVersion}";

    inherit src;

    enableParallelBuilding = true;

    buildInputs =
      [ pkgconfig libpng gtk perl zip libIDL libjpeg zlib bzip2 python
        dbus dbus_glib pango freetype fontconfig alsaLib nspr nss libnotify
        xlibs.pixman yasm mesa sqlite file unzip pysqlite
        hunspell libevent libstartup_notification libvpx cairo
        gstreamer gst_plugins_base icu
      ];

    patches = [
      ./disable-reporter.patch # fixes "search box not working when built on xulrunner"
      ./xpidl.patch
    ];

    propagatedBuildInputs = [xulrunner];

    configureFlags =
      [ "--enable-application=browser"
        "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
        "--enable-chrome-format=jar"
      ]
      ++ commonConfigureFlags
      ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

    makeFlags = [
      "SYSTEM_LIBXUL=1"
    ];

    # Because preConfigure runs configure from a subdirectory.
    configureScript = "../configure";

    preConfigure =
      ''
        # Hack to work around make's idea of -lbz2 dependency
        find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
          stdenv.lib.concatStringsSep ":"
            (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
        }' ';'

        # Building directly in the main source directory is not allowed.
        mkdir obj_dir
        cd obj_dir
      '';

    postInstall =
      ''
        ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $(echo $out/lib/firefox-*)/xulrunner
        cd "$out/lib/"firefox-*
        rm firefox
        echo -e '#!${stdenv.shell}\nexec ${xulrunner}/bin/xulrunner "'"$PWD"'/application.ini" "$@"' > firefox
        chmod a+x firefox

        # Put chrome.manifest etc. in the right place.
        mv browser/* .
        rmdir browser
      ''; # */

    meta = {
      description = "Mozilla Firefox - the browser, reloaded";
      homepage = http://www.mozilla.com/en-US/firefox/;
      maintainers = with stdenv.lib.maintainers; [ eelco wizeman ];
    };

    passthru = {
      inherit gtk xulrunner nspr;
      isFirefox3Like = true;
    };
  };
}
