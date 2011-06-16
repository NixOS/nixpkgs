{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, yasm, mesa

, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

assert stdenv.gcc ? libc && stdenv.gcc.libc != null;

rec {

  firefoxVersion = "5.0";
  
  xulVersion = "5.0"; # this attribute is used by other packages

  versionSuffix = "-rc1";

  
  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/5.0-candidates/build1/source/firefox-${firefoxVersion}.source.tar.bz2";
    sha256 = "0i6zxvhvf717bzz3mwlbvrk601k81r38fym0fv2nlvr9r207vybb";
  };

  
  commonConfigureFlags =
    [ "--enable-optimize"
      "--disable-debug"
      "--enable-strip"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      # "--with-system-nss"
      # "--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
      # Disabled system Cairo for now because it causes gradients in tabs etc. to be missing.
      # "--enable-system-cairo"
      # Compiling with the Nixpkgs SQLite gives:
      # "configure: error: System SQLite library is not compiled with SQLITE_SECURE_DELETE."
      # "--enable-system-sqlite"
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
      "--disable-installer" 
      "--disable-updater"
    ];


  xulrunner = stdenv.mkDerivation rec {
    name = "xulrunner-${xulVersion}${versionSuffix}";
    
    inherit src;

    buildInputs =
      [ pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
        python dbus dbus_glib pango freetype fontconfig xlibs.libXi
        xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
        alsaLib nspr /* nss */ libnotify xlibs.pixman yasm mesa
	xlibs.libXScrnSaver xlibs.scrnsaverproto
	xlibs.libXext xlibs.xextproto
      ];

    configureFlags =
      [ "--enable-application=xulrunner"
        "--disable-javaxpcom"
      ] ++ commonConfigureFlags;

    enableParallelBuilding = true;
      
    # Hack to work around make's idea of -lbz2 dependency
    preConfigure =
      ''
        find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
          stdenv.lib.concatStringsSep ":" 
            (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
        }' ';'
      '';

    # !!! Temporary hack.
    preBuild =
      ''
        export NIX_ENFORCE_PURITY=
      '';

    installFlags = "SKIP_GRE_REGISTRATION=1";

    postInstall = ''
      # Fix some references to /bin paths in the Xulrunner shell script.
      substituteInPlace $out/bin/xulrunner \
          --replace /bin/pwd "$(type -tP pwd)" \
          --replace /bin/ls "$(type -tP ls)"

      # Fix run-mozilla.sh search
      libDir=$(cd $out/lib && ls -d xulrunner-[0-9]*)
      echo libDir: $libDir
      test -n "$libDir"
      cd $out/bin
      mv xulrunner ../lib/$libDir/

      for i in $out/lib/$libDir/*; do 
          file $i;
          if file $i | grep executable &>/dev/null; then 
              ln -s $i $out/bin
          fi;
      done;
      rm -f $out/bin/run-mozilla.sh
    ''; # */

    meta = {
      description = "Mozilla Firefox XUL runner";
      homepage = http://www.mozilla.com/en-US/firefox/;
    };

    passthru = { inherit gtk; version = xulVersion; };
  };


  firefox = stdenv.mkDerivation rec {
    name = "firefox-${firefoxVersion}${versionSuffix}";

    inherit src;

    enableParallelBuilding = true;
      
    buildInputs =
      [ pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2 python
        dbus dbus_glib pango freetype fontconfig alsaLib nspr libnotify
        xlibs.pixman yasm mesa
      ];

    propagatedBuildInputs = [xulrunner];

    configureFlags =
      [ "--enable-application=browser"
        "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
        "--enable-chrome-format=jar"
      ]
      ++ commonConfigureFlags
      ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

    # Hack to work around make's idea of -lbz2 dependency
    preConfigure =
      ''
        find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
          stdenv.lib.concatStringsSep ":" 
            (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
        }' ';'
      '';

    postInstall =
      ''
        ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $(echo $out/lib/firefox-*)/xulrunner
      ''; # */

    meta = {
      description = "Mozilla Firefox - the browser, reloaded";
      homepage = http://www.mozilla.com/en-US/firefox/;
    };

    passthru = {
      inherit gtk xulrunner nspr;
      isFirefox3Like = true;
    };
  };
}
