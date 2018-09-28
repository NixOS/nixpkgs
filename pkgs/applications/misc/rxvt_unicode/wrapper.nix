{ symlinkJoin, rxvt_unicode, makeWrapper, glibcLocales, plugins }:

let
  rxvt_name = builtins.parseDrvName rxvt_unicode.name;

in symlinkJoin {
  name = "${rxvt_name.name}-with-plugins-${rxvt_name.version}";

  paths = [ rxvt_unicode ] ++ plugins;

  buildInputs = [ makeWrapper glibcLocales ];

  postBuild = ''
    wrapProgram $out/bin/urxvt \
      --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
    wrapProgram $out/bin/urxvtd \
      --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
  '';

  passthru.plugins = plugins;
}
