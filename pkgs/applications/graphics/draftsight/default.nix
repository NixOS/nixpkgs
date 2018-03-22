{ stdenv, requireFile, dpkg, makeWrapper, gcc, libGLU_combined, xdg_utils,
  dbus_tools, alsaLib, cups, fontconfig, glib, icu, libpng12,
  xkeyboard_config, gstreamer, zlib, libxslt, libxml2, sqlite, orc,
  libX11, libXcursor, libXrandr, libxcb, libXi, libSM, libICE,
  libXrender, libXcomposite }:

assert stdenv.system == "x86_64-linux";

let version = "2017-SP2"; in
stdenv.mkDerivation {
  name = "draftsight-${version}";

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
    for lib in $out/draftsight/opt/dassault-systemes/DraftSight/Libraries/*.so; do
      # DraftSight ships with broken symlinks for some reason
      if [ -f $(readlink -f $lib) ]
      then
        echo "Patching $lib..."
        patchelf --set-rpath $libPath:\$ORIGIN/../Libraries $lib
      else
        echo "Ignoring broken link $lib"
      fi
    done
  '';

  # TODO: Figure out why HelpGuide segfaults at startup.

  # This must be here for main window graphics to appear (without it
  # it also gives the error: "QXcbIntegration: Cannot create platform
  # OpenGL context, neither GLX nor EGL are enabled"). My guess is
  # that it dlopen()'s libraries in paths removed by shrinking RPATH.
  dontPatchELF = true;

  src = requireFile {
    name = "draftSight.deb";
    url = "https://www.3ds.com/?eID=3ds_brand_download&uid=41&pidDown=13426&L=0";
    sha256 = "04i3dqza6y4p2059pqg5inp3qzr5jmiqplzzk7h1a6gh380v1rbr";
  };

  libPath = stdenv.lib.makeLibraryPath [ gcc.cc libGLU_combined xdg_utils
    dbus_tools alsaLib cups.lib fontconfig glib icu libpng12
    xkeyboard_config gstreamer zlib libxslt libxml2 sqlite orc libX11
    libXcursor libXrandr libxcb libXi libSM libICE libXrender
    libXcomposite ];

  meta = with stdenv.lib; {
    description = "2D design & drafting application, meant to be similar to AutoCAD";
    longDescription = "Professional-grade 2D design and drafting solution from Dassault Systèmes that lets you create, edit, view and mark up any kind of 2D CAD drawing.";
    homepage = https://www.3ds.com/products-services/draftsight-cad-software/;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.linux;
  };
}
