{ buildEnv, avidemux_unwrapped, makeWrapper
# GTK version is broken upstream, see https://bugzilla.redhat.com/show_bug.cgi?id=1244340
, withUi ? "qt4"
}:

let ui = builtins.getAttr "avidemux_${withUi}" avidemux_unwrapped; in

assert ui.isUi;

buildEnv {
  name = "avidemux-${withUi}-" + ui.version;

  paths = [ ui avidemux_unwrapped.avidemux_common avidemux_unwrapped.avidemux_settings ];

  ignoreCollisions = true;

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

  meta = ui.meta;
}
