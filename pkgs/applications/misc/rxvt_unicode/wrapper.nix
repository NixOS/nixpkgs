{ stdenv, symlinkJoin, rxvt_unicode, makeWrapper, plugins }:

let
  rxvt = rxvt_unicode.override {
    perlSupport = true;
  };
  rxvt_name = builtins.parseDrvName rxvt.name;

in symlinkJoin {
  name = "${rxvt_name.name}-with-plugins-${rxvt_name.version}";

  paths = [ rxvt ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/urxvt \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
    wrapProgram $out/bin/urxvtd \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
  '';
}
