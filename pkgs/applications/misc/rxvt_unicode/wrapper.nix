{ symlinkJoin, rxvt_unicode, makeWrapper, plugins, perlPackages, perlDeps ? []}:

let
  rxvt_name = builtins.parseDrvName rxvt_unicode.name;

in symlinkJoin {
  name = "${rxvt_name.name}-with-plugins-${rxvt_name.version}";

  paths = [ rxvt_unicode ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/urxvt \
      --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
    wrapProgram $out/bin/urxvtd \
      --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
      --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
  '';

  passthru.plugins = plugins;
}
