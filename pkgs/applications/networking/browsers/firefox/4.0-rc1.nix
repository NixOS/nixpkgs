{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file, alsaLib, nspr, nss, libnotify
, libvpx, yasm, mesa, wirelesstools

, # If you want the resulting program to call itself "Firefox" instead
  # of "Shiretoko" or whatever, enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

rec {

  firefoxVersion = "4.0rc1";
  
  xulVersion = "2.0"; # this attribute is used by other packages

  
  src = fetchurl {
    url = "http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.bz2";
    sha256 = "8bae4af5d364c6caa624ad106f532f046f23e6187281cf87d8d4ed5d899f100f";
  };

  commonConfigureFlags =
    [ "--enable-optimize"
      "--disable-debug"
      "--enable-strip"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      #"--with-system-nss"
      # "--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
      "--enable-system-cairo"
      #"--enable-system-sqlite" # <-- this seems to be discouraged
      "--disable-crashreporter"
      "--disable-tests"
      "--disable-necko-wifi" # maybe we want to enable this at some point
    ];


  xulrunner = stdenv.mkDerivation rec {
    name = "xulrunner-${xulVersion}";
    
    inherit src;

    buildInputs =
    [ pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
        python dbus dbus_glib pango freetype fontconfig xlibs.libXi
        xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt file
        alsaLib nspr /* nss */ libnotify xlibs.pixman libvpx yasm mesa
	wirelesstools xlibs.libXScrnSaver xlibs.scrnsaverproto
	xlibs.libXext xlibs.xextproto
      ];

    configureFlags =
      [ "--enable-application=xulrunner"
        "--disable-javaxpcom"
      ] ++ commonConfigureFlags;

    # !!! Temporary hack.
    preBuild = ''
     export NIX_ENFORCE_PURITY=
    '';

    # Hack to work around make's idea of -lbz2 dependency
    preConfigure = ''
     find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
       stdenv.lib.concatStringsSep ":" 
         (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
     }' ';'
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
    name = "firefox-${firefoxVersion}";

    inherit src;

    buildInputs =
      [ pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2 python
        dbus dbus_glib pango freetype fontconfig alsaLib nspr libnotify
        xlibs.pixman libvpx yasm mesa wirelesstools
      ];

    propagatedBuildInputs = [xulrunner];

    configureFlags =
      [ "--enable-application=browser"
        "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
      ]
      ++ commonConfigureFlags
      ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

    postInstall = ''
      libDir=$(cd $out/lib && ls -d firefox-[0-9]*)
      test -n "$libDir"

      ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $out/lib/$libDir/xulrunner

      # Register extensions etc. !!! is this needed anymore?
      echo "running firefox -register..."
      $out/bin/firefox -register
    ''; # */

    # Hack to work around make's idea of -lbz2 dependency
    preConfigure = ''
     find . -name Makefile.in -execdir sed -i '{}' -e '1ivpath %.so ${
       stdenv.lib.concatStringsSep ":" 
         (map (s : s + "/lib") (buildInputs ++ [stdenv.gcc.libc]))
     }' ';'
    '';

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
