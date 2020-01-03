{ stdenv, fetchurl, dpkg, makeWrapper, gcc, libGLU, libGL, xdg_utils,
  dbus, alsaLib, cups, fontconfig, glib, icu, libpng12,
  xkeyboard_config, zlib, libxslt, libxml2, sqlite, orc,
  libX11, libXcursor, libXrandr, libxcb, libXi, libSM, libICE,
  libXrender, libXcomposite }:

let version = "2018SP2"; in
stdenv.mkDerivation {
  pname = "draftsight";
  inherit version;

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    mkdir $out
    mkdir $out/draftsight
    dpkg -x $src $out/draftsight
  '';

  # Both executables and bundled libraries need patching to find their
  # dependencies.  The makeWrapper & QT_XKB_CONFIG_ROOT is to
  # alleviate "xkbcommon: ERROR: failed to add default include path
  # /usr/share/X11/xkb" and "Qt: Failed to create XKB context!".
  installPhase = ''
    mkdir $out/bin
    for exe in DraftSight dsHttpApiController dsHttpApiService FxCrashRptApp HelpGuide; do
      echo "Patching $exe..."
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath $libPath:\$ORIGIN/../Libraries \
               $out/draftsight/opt/dassault-systemes/DraftSight/Linux/$exe
      makeWrapper $out/draftsight/opt/dassault-systemes/DraftSight/Linux/$exe \
          $out/bin/$exe \
          --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"
    done
    for lib in $out/draftsight/opt/dassault-systemes/DraftSight/Libraries/*.so*; do
      # DraftSight ships with broken symlinks for some reason
      if [ -f $(readlink -f $lib) ]
      then
        echo "Patching $lib..."
        patchelf --set-rpath $libPath:\$ORIGIN/../Libraries $lib
      else
        echo "Ignoring broken link $lib"
      fi
    done
    for lib in $out/draftsight/opt/dassault-systemes/DraftSight/APISDK/lib/cpp/*.so*; do
      if [ -f $(readlink $lib) ]
      then
        echo "Patching $lib..."
        chmod u+w $lib
        patchelf --set-rpath $libPath:\$ORIGIN/../Libraries $lib
      else
        echo "Ignoring broken link $lib"
      fi
    done
    # These libraries shouldn't really be here anyway:
    find $out/draftsight/opt/dassault-systemes/DraftSight/APISDK/Samples/C++ \
         -type d -name _lib | xargs rm -r
  '';

  # TODO: Figure out why HelpGuide segfaults at startup.

  # This must be here for main window graphics to appear (without it
  # it also gives the error: "QXcbIntegration: Cannot create platform
  # OpenGL context, neither GLX nor EGL are enabled"). My guess is
  # that it dlopen()'s libraries in paths removed by shrinking RPATH.
  dontPatchELF = true;

  src = fetchurl {
    name = "draftSight.deb";
    url = "http://dl-ak.solidworks.com/nonsecure/draftsight/${version}/draftSight.deb";
    sha256 = "05lrvml0zkzqg0sj6sj2h8h66hxdmsw5fg9fwz923r1y8j48qxdx";
  };

  libPath = stdenv.lib.makeLibraryPath [ gcc.cc libGLU libGL xdg_utils
    dbus alsaLib cups.lib fontconfig glib icu libpng12
    xkeyboard_config zlib libxslt libxml2 sqlite orc libX11
    libXcursor libXrandr libxcb libXi libSM libICE libXrender
    libXcomposite ];

  meta = with stdenv.lib; {
    description = "2D design & drafting application, meant to be similar to AutoCAD";
    longDescription = "Professional-grade 2D design and drafting solution from Dassault Systèmes that lets you create, edit, view and mark up any kind of 2D CAD drawing.";
    homepage = https://www.3ds.com/products-services/draftsight-cad-software/;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ hodapp ];
    platforms = [ "x86_64-linux" ];
  };
}
