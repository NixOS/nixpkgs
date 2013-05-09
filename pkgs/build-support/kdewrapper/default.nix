{ stdenv, kde4, shared_mime_info, extraLibs ? [] }:

/* Supply a KDE program, and it will have the necessary KDE vars to
  get icons, mime types, etc. working.
  For example:
  
  packageOverrides = pkgs : {
    kdenliveWrapped = kde4.wrapper kde4.kdenlive;
  };
  */
program:

let
  libs = with kde4; [ kdelibs kde_runtime oxygen_icons shared_mime_info ]
    ++ extraLibs;
in
stdenv.mkDerivation {
  name = program.name + "-wrapped";

  inherit libs;

  buildCommand = ''
    ensureDir $out/bin

    KDEDIRS=
    QT_PLUGIN_PATH=
    for a in $libs; do
      KDEDIRS=$a''${KDEDIRS:+:}$KDEDIRS
      QT_PLUGIN_PATH=$a/lib/qt4/plugins:$a/lib/kde4/plugins''${QT_PLUGIN_PATH:+:}$QT_PLUGIN_PATH
    done
    for a in ${program}/bin/*; do 
      PROG=$out/bin/`basename $a` 
    cat > $PROG << END
      export KDEDIRS=$KDEDIRS\''${KDEDIRS:+:}\$KDEDIRS
      export QT_PLUGIN_PATH=$QT_PLUGIN_PATH\''${QT_PLUGIN_PATH:+:}\$QT_PLUGIN_PATH
      exec $a "\$@"
    END
    chmod +x $PROG
    done
  '';
}
