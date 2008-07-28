{ stdenv, fetchurl, lzma, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig }:

let version = "3.0.1-g1"; in
stdenv.mkDerivation {
  name = "icecat-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnuzilla/${version}/icecat-${version}.tar.lzma";
    sha256 = "042znp8zi5m6ihvm8lz4f07x27yjjqbs20sgzb114wrh0xa2mwd0";
  };

  buildInputs = [
    lzma
    pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig
    xlibs.libXi xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt
  ];

  unpackCmd = "lzma -d < $src | tar xv";

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-strip"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-bz2"
    # "--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
    "--enable-system-cairo" # <-- disabled for now because IceCat needs a alpha version of Cairo
    #"--enable-system-sqlite" # <-- this seems to be discouraged
    "--disable-crashreporter"
  ];

  postInstall = ''
    export dontPatchELF=1;

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # Fix some references to /bin paths in the IceCat shell script.
    substituteInPlace $out/bin/icecat \
        --replace /bin/pwd "$(type -tP pwd)" \
        --replace /bin/ls "$(type -tP ls)"
    
    # This fixes starting IceCat when there already is a running
    # instance.  The `icecat' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d icecat-[0-9]*)
    test -n "$libDir"
    cd $out/bin
    mv icecat ../lib/$libDir/
    ln -s ../lib/$libDir/icecat .

    # Register extensions etc.
    echo "running icecat -register..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./icecat-bin -register) || false

    # Put the GNU IceCat icon in the right place.
    ensureDir $out/lib/$libDir/chrome/icons/default
    ln -s ../../../icons/default.xpm  $out/lib/$libDir/chrome/icons/default/
  ''; # */

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
  };

  passthru = {inherit gtk;};
}


