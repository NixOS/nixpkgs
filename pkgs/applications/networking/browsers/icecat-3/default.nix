{ fetchurl, stdenv, xz, pkgconfig, gtk, pango, perl, python, ply, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs, alsaLib
, libnotify, gnomevfs, libgnomeui
, freetype, fontconfig, wirelesstools ? null, pixman
, application ? "browser" }:

# Build the WiFi stuff on Linux-based systems.
# FIXME: Disable for now until it can actually be built:
# http://thread.gmane.org/gmane.comp.gnu.gnuzilla/1376 .
#assert stdenv.isLinux -> (wirelesstools != null);

let version = "3.6.7"; in
stdenv.mkDerivation {
  name = "icecat-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnuzilla/${version}/icecat-${version}.tar.xz";
    sha256 = "0nm0py3kd55pgyx1yv44v1acq5d1rgka3p6msfbgqx60yd38rwsm";
  };

  buildInputs =
    [ xz libgnomeui libnotify gnomevfs alsaLib
      pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2 pixman
      python ply dbus dbus_glib pango freetype fontconfig
      xlibs.libXi xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt
    ]
    ++ (stdenv.lib.optional false /* stdenv.isLinux */ wirelesstools);

  patches = [
    ./skip-gre-registration.patch ./rpath-link.patch
  ];

  configureFlags =
    [ "--enable-application=${application}"
      "--enable-libxul"
      "--disable-javaxpcom"

      "--enable-optimize"
      "--disable-debug"
      "--enable-strip"
      "--with-system-jpeg"
      "--with-system-zlib"
      "--with-system-bz2"
      # "--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
      "--enable-system-cairo"
      #"--enable-system-sqlite" # <-- this seems to be discouraged
      "--disable-crashreporter"
    ]
    ++ (stdenv.lib.optional true /* (!stdenv.isLinux) */ "--disable-necko-wifi");

  postInstall = ''
    export dontPatchELF=1;

    # Strip some more stuff
    strip -S "$out/lib/"*"/"* || true

    # This fixes starting IceCat when there already is a running
    # instance.  The `icecat' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d icecat-[0-9]*)
    test -n "$libDir"

    if [ -f "$out/bin/icecat" ]
    then
        # Fix references to /bin paths in the IceCat shell script.
        substituteInPlace $out/bin/icecat		\
            --replace /bin/pwd "$(type -tP pwd)"	\
            --replace /bin/ls "$(type -tP ls)"

        cd $out/bin
        mv icecat ../lib/$libDir/
        ln -s ../lib/$libDir/icecat .

        # Register extensions etc.
        echo "running \`icecat -register'..."
        (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./icecat-bin -register) || false
    fi

    if [ -f "$out/lib/$libDir/xpidl" ]
    then
        # XulRunner's IDL compiler.
        echo "linking \`xpidl'..."
        ln -s "$out/lib/$libDir/xpidl" "$out/bin"
    fi

    # Put the GNU IceCat icon in the right place.
    ensureDir "$out/lib/$libDir/chrome/icons/default"
    ln -s ../../../icons/default.xpm  "$out/lib/$libDir/chrome/icons/default/"
  '';

  meta = {
    description = "GNU IceCat, a free web browser based on Mozilla Firefox";

    longDescription = ''
      Gnuzilla is the GNU version of the Mozilla suite, and GNU IceCat
      is the GNU version of the Firefox browser.  Its main advantage
      is an ethical one: it is entirely free software.  While the
      source code from the Mozilla project is free software, the
      binaries that they release include additional non-free software.
      Also, they distribute and recommend non-free software as
      plug-ins.  In addition, GNU IceCat includes some privacy
      protection features.
    '';

    homepage = http://www.gnu.org/software/gnuzilla/;
    licenses = [ "GPLv2+" "LGPLv2+" "MPLv1+" ];

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };

  passthru = {
    inherit gtk version;
    isFirefox3Like = true;
  };
}
