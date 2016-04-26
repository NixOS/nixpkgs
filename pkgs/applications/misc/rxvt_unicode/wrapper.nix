{ stdenv, symlinkJoin, rxvt_unicode, makeWrapper, plugins }:

let
  rxvt = rxvt_unicode.override {
    perlSupport = true;
  };

in symlinkJoin {
  name = "${rxvt.name}-with-plugins";

  paths = [ rxvt ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/urxvt \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
    wrapProgram $out/bin/urxvtd \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
  '';
}
