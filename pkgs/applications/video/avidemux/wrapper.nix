{ buildEnv, avidemux, makeWrapper
# GTK version is broken upstream, see https://bugzilla.redhat.com/show_bug.cgi?id=1244340
, withUi ? "qt4"
}:

let
  ui = builtins.getAttr withUi avidemux;

in buildEnv {
  name = "avidemux-${withUi}-" + avidemux.version;

  paths = [ avidemux ui ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${ui}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    for i in $out/bin/*; do
      wrapProgram $i --set ADM_ROOT_DIR $out
    done
  '';
}
