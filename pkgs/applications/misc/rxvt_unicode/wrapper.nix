{ stdenv, buildEnv, rxvt_unicode, makeWrapper, plugins }:

let
  rxvt = rxvt_unicode.override {
    perlSupport = true;
  };

  drv = buildEnv {
    name = "${rxvt.name}-with-plugins";

    paths = [ rxvt ] ++ plugins;

    postBuild = ''
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
  };
in stdenv.lib.overrideDerivation drv (x : { buildInputs = x.buildInputs ++ [ makeWrapper ]; })