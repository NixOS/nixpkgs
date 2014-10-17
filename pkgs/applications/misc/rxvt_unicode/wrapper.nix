{ stdenv, buildEnv, rxvt_unicode, makeWrapper, plugins }:

let
  rxvt = rxvt_unicode.override {
    perlSupport = true;
  };

in
buildEnv {
  name = "${rxvt.name}-with-plugins";

  paths = [ rxvt ] ++ plugins;

  postBuild = ''
    buildInputs=${makeWrapper}
    source ${stdenv}/setup
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${rxvt}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/urxvt \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
  '';
}
